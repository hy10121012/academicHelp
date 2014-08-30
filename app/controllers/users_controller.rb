class UsersController < ApplicationController
  skip_before_filter :authorize, :only => ['create']

  def create
    if (!User.exist?(params[:user][:email]))
      puts params[:user].except(:submit).inspect
      user = User.create(user_params)
      user.save
      session[:user_id] = user.id
      session[:user_type_id] = user.user_type_id
      redirect_to '/home'
    else
      redirect_to '/'
    end
  end

  def update

  end

  def show
    @user = User.find(params[:id])
    @votes = Vote.find_vote(params[:id])
    @comments = Comment.find_all_by_to_user_id(params[:id])
    @request_count = Request.count_request_by_type(params[:id])
  end

  def my_profile
    @user = User.find(session[:user_id])
    @votes = Vote.find_vote(session[:user_id])
    @comments = Comment.find_all_by_to_user_id(session[:user_id])
    @request_count = Request.count_request_by_type(session[:user_id])
    render :show
  end


  def destory
  end

  def new
  end

  private
  def user_params
    params.require(:user).permit(:first, :last, :password, :email, :subject, :education_id, :university, :country, :user_type_id, :subject_area_id)
  end

end
