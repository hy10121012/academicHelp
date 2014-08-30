require 'test_helper'

class RequestFilesControllerTest < ActionController::TestCase
  test "should get do_upload_file" do
    get :do_upload_file
    assert_response :success
  end

end
