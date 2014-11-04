#coding: utf-8
class WelcomeController < ApplicationController

  skip_before_filter :authorize
  def welcome
    @users = User.get_welcome_page_user
    @requests = Request.get_home_page_request
    @user_count = User.get_home_page_user_count
    @count,@sum = Request.get_home_page_amount_count
  end

  def login

  end

  def logout
    session.destroy
    redirect_to '/'
  end

  def register_success

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
      session[:user_id]= user.id;
      session[:user_first]= user.first;
      session[:user_last]= user.last;
      session[:user_type_id]= user.user_type_id;
      if(user.is_validated)
        redirect_to '/home'
      else
        redirect_to '/validate_user'
      end
    else
      puts "incorrect_token #{Digest::MD5.hexdigest(user.id.to_s+user.email)}== #{params[:token]}"
    end

  end

  def reset_pass
    users = User.where(:email=>params[:email])
    @token = params[:token]
    @email = params[:email]
    if(users.size ==1)
      user = users[0]
      if(Digest::MD5.hexdigest(user.id.to_s+user.password)==@token)

      else
        redirect_to '/'
      end
    else
      redirect_to '/'
    end
  end

  def do_reset_pass
    users = User.where(:email=>params[:email])
    token = params[:token]
    if(users.size ==1)
      user = users[0]
      if(Digest::MD5.hexdigest(user.id.to_s+user.password)==token)
        user.password = (Digest::MD5.hexdigest(params[:pass]))
        user.save
        redirect_to :action=>'reset_sucess'
      else
        redirect_to '/'
      end
    else
      redirect_to '/'
    end
  end

  def reset_sucess

  end

  def resend_email

  end

  def do_resend_email
    user = User.find_by_email(params[:email])
    if user.nil?
      puts "cannot find user"
      @success=false
    else
      if(user.first==params[:first] && user.last==params[:last])
        WriterMailer.send_forgot_password(user).deliver
        @success=true
      else
        puts user.inspect
        puts "first or last name incorrect received first:#{user.first}-> #{params[:first]} last:#{user.last}-> #{params[:last]}"
        @success=false
      end
    end

  end

  def login_check
    user = User.find_by_email(params[:email])
    if(!user.nil?)
      if(user.password==Digest::MD5.hexdigest(params[:password]))
        if(user.is_active==true)
          session[:user_id]= user.id;
          session[:user_first]= user.first;
          session[:user_last]= user.last;
          session[:user_type_id]= user.user_type_id;
          redirect_to '/home'
        else
          @message = "用户还没有激活,请通过发送到注册邮箱的邮件激活账号，如要重新发送激活邮件请点击<a href='/resend_email'>这里</a>"
        end
      else
        @message = "密码不正确"
      end
    else
      @message = "没有此用户"
    end
  end

  def forgot

  end

  def register
    render layout: 'blank'
  end

  def get_university_by_country_id
    @university = University.where(:country_id => params[:id])
    render :json => @university, :layout => false
  end
  def get_writer_university_by_country_id
    @university = University.where(:country_id => params[:id])
    render :json => @university, :layout => false
  end

  def find_university_by_input
    input = params[:input]
    country_id = params[:country_id]
    universities = University.where("name like '%#{input}%' and country_id=#{country_id}").limit(8)
    render :json => universities, :layout => false
  end


end
