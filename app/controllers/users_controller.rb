#coding: utf-8
class UsersController < ApplicationController
  skip_before_filter :authorize, :only => ['create']

  def create
    if (!User.exist?(params[:user][:email]))
      puts params[:user].except(:submit).inspect
      u = user_params
      u[:password] = Digest::MD5.hexdigest(u[:password])
      puts "---->#{u.inspect}"
      if !is_valid_user_data?(u)
        redirect_to '/'
      else
        u[:is_active] =false
        user = User.create(u)
        if user.save
          session[:user_id] = user.id
          session[:user_type_id] = user.user_type_id
          WriterMailer.welcome_email(user).deliver
          redirect_to '/register_success'
        else
          redirect_to '/'
        end
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

  def validate_user
    @writer_validation = WriterValidation.new
  end

  def do_validate_user
    validation = validation_params
    validation[:user_id] = session[:user_id];
    if WriterValidation.create(validation)
      redirect_to :action => "validate_user", :params => {:id => params[:id], :success => true}
    else
      redirect_to :action => "validate_user", :params => {:id => params[:id], :success => false}
    end
  end


  private
  def user_params
    params.require(:user).permit(:first, :last, :password, :email, :subject, :education_id, :university_id, :country_id, :user_type_id, :subject_area_id)
  end

  def is_valid_user_data?(user_data)
    user_data.each do |value|
      puts value.inspect
      if (value[1].nil? || value[1].length==0)
        return false
      end
    end
    return true
  end


  def validation_params
    params.require(:writer_validation).permit(:file)
  end

  def do_user_stats(user_id)
    @user = User.find(user_id)
    @votes = Vote.find_vote(user_id)
    @comments = Comment.where(:to_user_id => user_id)
    if (session[:user_type_id]==2)
      @request_count =Request.count_request_by_type_taker(user_id)
    else
      @request_count = Request.count_request_by_type_maker(user_id)
    end
  end

end
