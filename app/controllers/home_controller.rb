class HomeController < ApplicationController
  def writer
    @request_allocations = RequestAllocation.where("request_allocations.taker_id = #{session[:user_id]}")
    @summary = {'total'=>0,'outstanding_amount'=>0,'argue'=>0,'processing'=>0};
    @summary['total'] =@request_allocations.count
    @request_allocations.each do |request_allocation|
      if(request_allocation.request.status ==(RequestStatus::HANDED_IN ) )
        @summary['outstanding_amount']+=request_allocation.request.price
      elsif(request_allocation.is_approved==true && request_allocation.request.status == RequestStatus::ARGUE)
        @summary['argue']+1
      elsif(request_allocation.is_approved==true && (request_allocation.request.status == RequestStatus::HANDED_IN || request_allocation.request.status == RequestStatus::AWAITING_PAYMENT ||request_allocation.request.status ==  RequestStatus::IN_PROCESS ))
        @summary['processing']+=1
      end
    end
    puts  @summary.inspect
    @request_logs = RequestLog.find_taker_logs_by_user_id(session[:user_id]).limit(10)
    @messages = Message.find_by_taker_id(session[:user_id])

  end

  def requester
    @requests = Request.find_all_by_user_id(session[:user_id])
    @summary = {'total'=>0,'outstanding_amount'=>0,'argue'=>0,'processing'=>0};
    @summary['total'] =@requests.count
    @requests.each do |request|
      if(request.status == RequestStatus::AWAITING_PAYMENT)
        @summary['outstanding_amount']+=request.price
      elsif(request.status == RequestStatus::ARGUE)
        @summary['argue']+1
      elsif(request.status != RequestStatus::ARGUE && request.status != RequestStatus::CLOSED && request.status != RequestStatus::CANCELLED)
        @summary['processing']+=1
      end
    end
    @request_logs = RequestLog.find_maker_logs_by_user_id(session[:user_id]).limit(10)
    @messages = Message.find_by_maker_id(session[:user_id])
  end
end
