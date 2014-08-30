class RequestFilesController < ApplicationController
  def do_upload_file
    request_file =upload_file_to_request;
    RequestFile.create(request_file)
  end


  private
  def upload_file_to_request
    params.require(:request_file).permit(:file, :description,:request_id)
  end
end
