#coding: utf-8
class WelcomeController < ApplicationController

  skip_before_filter :authorize
  def welcome
    render layout: 'welcome'
  end

  def login

  end

  def logout
    session.destroy
    redirect_to '/'
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
        WriterMailer.welcome_email(user).deliver
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
    render layout: 'application'
  end

end
