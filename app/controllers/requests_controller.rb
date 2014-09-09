class RequestsController < ApplicationController
  def new
    @user= User.find(session[:user_id])
  end


  def create
    request = Request.create(request_params)
    request.end_date = params[:request][:end_date].gsub '/', ''
    request.user_id =session[:user_id]
    request.status =RequestStatus::SUBMITTED
    request.create_request
  end

  def show
    @request = Request.find(params[:id])
    if(!@request.taker.nil?)
      @votes = Vote.find_vote(@request.taker.id)
    end
    @request_file = RequestFile.new
  end

  def maker_index
    @requests = Request.where("user_id=#{session[:user_id]}")
  end

  def taker_index
    @requests = Request.find_request_for_taker(session[:user_id])
  end

  def cancel
  end

  def market_index
    if (session[:user_type_id]==2)
      user = User.find(session[:user_id])
      @requests = Request.find_suitable_open_request(user)
    end
  end

  def do_cancel
    request = Request.find(params[:id])
    if (request.user_id==session[:user_id])
      request.maker_cancel(params[:reason])
    end
    redirect_to '/my_request'
  end

  def do_take_request
    if (session[:user_type_id]==2)
      request = Request.find(params[:id])
      request.assign_to_user(session[:user_id])
    end
    redirect_to '/my_request'
  end

  def submit

  end

  def do_submit
    request = Request.find(params[:id])
    if (request.taker.id == session[:user_id])
      if (submit_to_us)
        request.status=RequestStatus::HANDED_IN
        request.save
      end
    end
    redirect_to :action => 'show', :id => params[:id]
  end

  def close_down
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      request.status = RequestStatus::CLOSED
      request.request_allocation.is_success=1
      request.transaction do
        request.save
        request.request_allocation.save
      end
    end
  end

  def complaint
  end

  def do_complaint
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      request.status = RequestStatus::ARGUE
      request.request_allocation.is_success=1
      request.transaction do
        request.save
        request.request_allocation.save
      end
    end
    redirect_to :action => 'show', :id => params[:id]
  end

  def confirm_taker
    request = Request.find(params[:id])
    if (request.is_owner?(session[:user_id]))
      if (params[:a].to_i==1)
        request.accept_taker(params[:taker_id])
      elsif (params[:a].to_i==0)
        request.reject_taker(params[:taker_id])
      end
    end
    redirect_to '/my_request'
  end

  def do_pay
    request = Request.find(params[:id])
    if (pay_to_us)
      request.do_pay
    end
    redirect_to :action => 'show', :id => params[:id]
  end

  def taker_cancel
    request = Request.find(params[:id])
    if (request.taker.id == session[:user_id])
      request.status=RequestStatus::SUBMITTED
      request.request_allocation.is_success=0;
      request.transaction do
        request.request_allocation.save
        request.save
      end
    end
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


end
