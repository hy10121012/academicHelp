require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get destory" do
    get :destory
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
