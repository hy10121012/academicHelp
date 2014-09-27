#coding: utf-8
class UsersController < ApplicationController
  skip_before_filter :authorize, :only => ['create','activate_user']

  def create
    if (!User.exist?(params[:user][:email]))
      puts params[:user].except(:submit).inspect
      u  = user_params
      u[:password] = Digest::MD5.hexdigest(u[:password])
      u[:is_active] =false
      user = User.create(u)
      if user.save
        session[:user_id] = user.id
        session[:user_type_id] = user.user_type_id
        WriterMailer.welcome_email(user).deliver
        redirect_to '/home'
      else
        redirect_to '/'
      end
    else
      redirect_to '/'
    end
  end

  def update

  end

  def show
    do_user_stats(params[:id])
  end

  def my_profile
    do_user_stats(session[:user_id])
    render :show
  end


  def destory
  end

  def new
  end

  def activate_user
    email = params[:email]
    user = User.find_by_email(email)
    if(Digest::MD5.hexdigest(user.id.to_s+user.email)==params[:token])
      if(user.is_active.nil? || user.is_active==false)
        user.is_active=true;
        user.save
      else
        puts "already activated"
      end
    else
      puts "incorrect_token #{Digest::MD5.hexdigest(user.id.to_s+user.email)}== #{params[:token]}"
    end
    redirect_to :controller => "welcome", :action => "welcome"
  end



  private
  def user_params
    params.require(:user).permit(:first, :last, :password, :email, :subject, :education_id, :university, :country_id, :user_type_id, :subject_area_id)
  end

  def do_user_stats(user_id)
    @user = User.find(user_id)
    @votes = Vote.find_vote(user_id)
    @comments = Comment.where(:to_user_id=>user_id)
    if(session[:user_type_id]==2)
      @request_count =Request.count_request_by_type_taker(user_id)
    else
      @request_count = Request.count_request_by_type_maker(user_id)
    end
  end

end
