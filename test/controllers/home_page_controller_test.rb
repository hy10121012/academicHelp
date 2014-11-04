require 'test_helper'

class HomePageControllerTest < ActionController::TestCase
  test "should get verifyMaker" do
    get :verifyMaker
    assert_response :success
  end

  test "should get verifyTaker" do
    get :verifyTaker
    assert_response :success
  end

end
