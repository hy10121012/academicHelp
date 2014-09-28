#coding: utf-8
require 'digest/md5'
class WriterMailer < ActionMailer::Base
  before_filter :set_mailer_host

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = "http://zhuxuewang.co.uk"
  end
  default from: "hy10121012@hotmail.com"

  def welcome_email(user)
    @user = user
    @url  = "#{default_url_options[:host]}/user_activate/?email=#{user.email}&token=#{Digest::MD5.hexdigest(user.id.to_s+user.email)}"
    mail(:to => user.email, :subject => "你好#{user.first} #{user.last}， 感谢您注册助学网")
  end

  def send_new_task_mail(user,request)
    @user = user
    @request = request
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    mail(:to => user.email, :subject => "你好#{user.first} #{user.last}， 助学网 - 有人发布了一个适合您的任务。报酬:#{request.price}")
  end

  def send_request_paid_mail_maker(user,request)
    @user = user
    @request = request
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    mail(:to => user.email, :subject => "您已经了任务支付#{request.id}的报酬，我们将通知承接人开始履行义务")
  end

  def send_request_paid_mail_taker(user,request)
    @user = user
    @request = request
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    mail(:to => user.email, :subject => "用户发布人#{request.user_id}，已经了任务支付#{request.id}的报酬")
  end
end
