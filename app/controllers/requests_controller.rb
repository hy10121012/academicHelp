#coding: utf-8
class RequestsController < ApplicationController
  def new
    @user= User.find(session[:user_id])
  end


  def create
    request = Request.create(request_params)
    request.end_date = params[:request][:end_date].gsub '/', ''
    request.user_id =session[:user_id]
    request.status =RequestStatus::SUBMITTED
    if request.create_request
      send_email_to_appropriate_write(request)
    end
    redirect_to :action => 'created', :id=>request.id
  end
  def created
    @id=params[:id]
    request = Request.find(@id);
    if request.user_id != session[:user_id]
      redirect_to '/home'
    end
  end

  def show
    @request = Request.find(params[:id])
    @user= User.find(session[:user_id])
    if (!@request.taker.nil?)
    end
    @request_file = RequestFile.new
    @request_submits = RequestSubmit.request_grouped_submits(@request.id)
  end

  def maker_index
    @requests = Request.where("user_id=#{session[:user_id]}").order("id desc")
  end

  def taker_index
    @requests = Request.find_request_for_taker(session[:user_id])
  end

  def submitted

  end


  def cancel
  end

  def payment
    @request = Request.find(params[:id])
    @paypal = PaypalInterface.new(@request)
    @paypal.express_checkout
    if @paypal.express_checkout_response.success?
      @paypal_url = @paypal.api.express_checkout_url(@paypal.express_checkout_response)
    else
      @error_message = @paypal.express_checkout_response
      @error=true;
    end
  end

  def paid
    request = Request.find(params[:id])
    success, details = request.do_pay(params[:token], params[:PayerID])
    if success
      payment_history = PaymentHistory.new
      payment_history.user_id=request.user_id
      payment_history.request_id=request.id
      payment_history.original_amount=request.price
      payment_history.fee_rate=SysProperty.get_maker_benchmark
      payment_history.user_pay = true
      payment_history.payment_token= params[:token]
      payment_history.payerID = params[:PayerID]
      payment_history.save
      send_paid_email_to_taker_and_maker(request)
      redirect_to :action => 'has_paid'
    else
      @error_message = details.LongMessage
    end
  end

  def has_paid

  end

  def revoked
    redirect_to :action => 'show', :id => params[:id]
  end

  def ipn
  end

  def market_index
    if (session[:user_type_id]==2)
      user = User.find(session[:user_id])
      @requests = Request.find_suitable_open_request(user)
    end
  end

  def do_maker_cancel
    request = Request.find(params[:id])
    if (request.user_id==session[:user_id])
      request.maker_cancel(params[:reason])
    end
    redirect_to '/my_request'
  end

  def do_take_request
    if (session[:user_type_id]==2)
      self_user = User.find(session[:user_id])
      if(self_user.is_validated==true)
        request = Request.find(params[:id])
        bid =request.price
        if params[:bid].to_i>0
          bid = params[:bid]
        end
        request.assign_to_user(session[:user_id],bid)
        MakerMailer.send_taker_take_task(self_user,request).deliver
        redirect_to '/my_request'
      else
        @error_message = "fa"
        redirect_to :controller => "requests", :action => "show", :params => {:id=> params[:id],:status=>@error_message}
      end
    end
  end

  def submit

  end

  def do_submit
    request = Request.find(params[:id])
    if request.latest_approved_submit.nil? || request.latest_approved_submit.process< params[:process].to_i
      request_file = params.require(:request_file).permit(:file, :request_id)
      if (request.user_id ==session[:user_id])
        request_file[:is_maker_upload]=true
      else
        request_file[:is_maker_upload]=false
      end
      if (params[:process].to_i<100)
        request_file[:description] = "#{params[:process]}%完成度预览"
      else
        request_file[:description] = "最终版本任务作业上传"
      end

      request_file[:user_id] =session[:user_id]
      file = RequestFile.create(request_file)
      if file.save
        request_submit = RequestSubmit.new
        request_submit.user_id = session[:user_id]
        request_submit.request_id = params[:id]
        request_submit.request_file_id= file.id
        request_submit.process=params[:process]
        request_submit.is_approved=nil;
        request_submit.is_latest_version=1;
        request_log = RequestLog.new
        request_log.user_id = session[:user_id]
        request_log.action = RequestAction::SUBMIT_PROCESS
        request_log.request_id= params[:id]
        request.transaction do
          if (request.taker.id == session[:user_id])
            if (submit_to_us)
              #if (params[:process].to_i==100)
              #  request.status=RequestStatus::HANDED_IN
              #  request.save
              #end
            end
          end
          if !request.latest_submit.nil?
            request.latest_submit.is_latest_version=0
            if request.latest_submit.is_approved.nil?
              request.latest_submit.is_approved=false
            end
            request.latest_submit.save
          end
          request_log.save
          request_submit.save
        end
        MakerMailer.send_taker_mark_progress(User.find(session[:user_id]),request,params[:process]).deliver
      end
    end
    redirect_to :action => 'submitted', :id => params[:id]
  end

  def do_complete
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      request.mark_as_accepted
      redirect_to :action => 'show', :id => params[:id]
    end
  end

  def close_down
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      vote = Vote.new
      comment = Comment.new
      comment.comment =params[:comment]
      comment.from_user_id=session[:user_id]
      comment.to_user_id= params[:taker_id]
      vote.vote_type=params[:rate]
      vote.from_user_id = session[:user_id]
      vote.to_user_id=params[:taker_id]
      request.taker_allocation.is_success=false
      request.taker_allocation.save
      vote.save
      comment.save
      request.close_request
    end
    redirect_to :action => 'show', :id => params[:id]
  end

  def complaint
  end

  def do_complaint
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      request.status = RequestStatus::ARGUE
      request.taker_allocation.is_success=1
      request.transaction do
        request.save
        request.taker_allocation.save
      end
    end
    redirect_to :action => 'show', :id => params[:id]
  end

  def confirm_taker
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      if (params[:a].to_i==1)
        request.accept_taker(params[:taker_id])
        WriterMailer.send_taker_accept_mail(User.find(params[:taker_id]),request).deliver
      elsif (params[:a].to_i==0)
        request.reject_taker(params[:taker_id])
      end
    end
    redirect_to :action=>'payment',:id=>params[:id]
  end

  def taker_cancel
    request = Request.find(params[:id])
    request.taker_cancel(session[:user_id])
    redirect_to :action => 'show', :id => params[:id]
  end

  def approve_process
    if params[:approve_action]=="approve"
      approve_submit

    elsif params[:approve_action]=="decline"
      decline_submit
    end
    render :text=>'1', :layout=>false
  end


  def approve_submit
    request_submit = RequestSubmit.find(params[:id])
    request_submit.approve
    if (request_submit.process.to_i==100)
      request = Request.find(request_submit.request_id)
      #request.update(status: RequestStatus::HANDED_IN)
      request.mark_as_accepted
    end
  end

  def decline_submit
    request_submit = RequestSubmit.find(params[:id])
    request_submit.decline
  end

  private
  def request_params
    params.require(:request).permit(:title, :requirement, :expected_score, :subject_area_id, :start_date, :end_date, :words, :request_type_id, :price)
  end

  def pay_to_us
    true
  end

  def submit_to_us
    true
  end

  def send_email_to_appropriate_write(request)
    user_list = User.joins("left join educations on educations.id = users.education_id").where("educations.level>=#{request.user.education.level} and users.subject_area_id=#{request.subject_area_id} and users.user_type_id=2")
    user_list.each do |user|
      WriterMailer.send_new_task_mail(user, request).deliver
    end
  end

  def send_paid_email_to_taker_and_maker(request)
    WriterMailer.send_request_paid_mail_maker(request.user, request).deliver
    WriterMailer.send_request_paid_mail_taker(request.taker, request).deliver
  end


end
