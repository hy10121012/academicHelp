require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get writer" do
    get :writer
    assert_response :success
  end

  test "should get requester" do
    get :requester
    assert_response :success
  end

end
