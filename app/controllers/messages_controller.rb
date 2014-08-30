class MessagesController < ApplicationController

  def form

  end

  def send_message
    save_message
    render :text=>"1"
  end

  def send_message_in_list
    if(params[:message][:message].to_s.length>0)
      save_message
    end
    redirect_to :controller=>'messages', :action=>'show' ,:id=> params[:message][:request_id]
  end


  def save_message
    request = Request.find(params[:message][:request_id])
    message = Message.new(message_params)
    message.maker_id = request.user_id
    message.taker_id = request.taker_allocation.taker_id
    message.is_maker_deleted=0;
    message.is_taker_deleted=0;
    message.save
  end

  def show
    @messages = Message.where(:request_id=>params[:request_id]).order("created_at desc")
  end

  private
  def message_params
    params.require(:message).permit(:from_user_id, :request_id, :message)
  end

end



