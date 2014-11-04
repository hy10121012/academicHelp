class RequestFilesController < ApplicationController
  def do_upload_file
    request_file =upload_file_to_request;
    if params[:request_file][:file].blank?
      redirect_to :controller => 'requests', :action => 'show', :id => request_file[:request_id]
    else
      request = Request.find(request_file[:request_id])
      if(request.user_id ==session[:user_id])
        request_file[:is_maker_upload]=true
      else
        request_file[:is_maker_upload]=false
      end
      request_file[:user_id] =session[:user_id]
      file = RequestFile.create(request_file)
      file.save
      request_log = RequestLog.new
      request_log.request_id = request_file[:request_id]
      request_log.user_id = session[:user_id]
      request_log.action = RequestAction::UPLOAD
      request_log.value = file.file_file_name
      request_log.value2= file.id
      request_log.save
      redirect_to :controller => 'requests', :action => 'show', :id => request_file[:request_id]
    end
  end


  def do_delete_file
    request_file = RequestFile.find(params[:id])
    request_file.is_deleted=1
    request_file.save
    render :text=>'1', :layout=>false
  end

  private
  def upload_file_to_request
    params.require(:request_file).permit(:file, :description,:request_id)
  end
end
