class HomeController < ApplicationController
  def writer
    @request_allocations = RequestAllocation.where("request_allocations.taker_id = #{session[:user_id]} and is_approved=1 and (is_success is null)")
    @pay_request = 0
    @request_allocations.each do |request_allocation|
      if (!request_allocation.request.latest_approved_submit.nil? && request_allocation.request.latest_approved_submit.process>0)
        @pay_request=1
      end
    end
    @summary = {'total' => 0, 'outstanding_amount' => 0, 'processing' => 0, 'closed' => 0, 'applying' => 0};
    @summary['total'] =@request_allocations.count
    @summary['applying'] = RequestAllocation.where("request_allocations.taker_id = #{session[:user_id]} and is_approved is null and is_user_cancelled is null").size
    @request_allocations.each do |request_allocation|
      if (!request_allocation.request.latest_approved_submit.nil? && request_allocation.request.latest_approved_submit.process>0)
        @summary['outstanding_amount']+=request_allocation.get_pay_amount
      end
      if (request_allocation.is_approved==true && request_allocation.request.status == RequestStatus::CLOSED)
        @summary['closed']+1
      elsif (request_allocation.is_approved==true && (request_allocation.request.status == RequestStatus::AWAITING_PAYMENT ||request_allocation.request.status == RequestStatus::IN_PROCESS))
        @summary['processing']+=1
      end
    end

    @request_logs = RequestLog.find_taker_logs_by_user_id(session[:user_id]).limit(10)
    #@messages = Message.find_by_taker_id(session[:user_id])

  end

  def requester
    @user = User.find(session[:user_id])
    @requests = Request.where(:user_id => session[:user_id]).order("created_at desc")
    @awaiting_pay = 0
    @requests.each do |request|
      if (request.status==RequestStatus::AWAITING_PAYMENT)
        @awaiting_pay=1
      end
    end
    @summary = {'total' => 0, 'outstanding_amount' => 0, 'argue' => 0, 'processing' => 0};
    @summary['total'] =@requests.count
    @requests.each do |request|
      if (request.status == RequestStatus::AWAITING_PAYMENT)
        @summary['outstanding_amount']+=request.price
      elsif (request.status == RequestStatus::ARGUE)
        @summary['argue']+1
      elsif (request.status != RequestStatus::ARGUE && request.status != RequestStatus::CLOSED && request.status != RequestStatus::CANCELLED)
        @summary['processing']+=1
      end
    end
    @request_logs = RequestLog.find_maker_logs_by_user_id(session[:user_id]).limit(10)
    puts @request_logs.inspect
    @messages = Message.find_by_maker_id(session[:user_id])
  end
end
