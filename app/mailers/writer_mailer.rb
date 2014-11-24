#coding: utf-8
require 'digest/md5'
class WriterMailer < ActionMailer::Base
  before_filter :set_mailer_host

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = "http://www.zhuxiewang.com"
  end
  default from: SysProperty.get_instance_email_address

  def welcome_email(user)
    @user = user
    @url  = "#{default_url_options[:host]}/user_activate/?email=#{user.email}&token=#{Digest::MD5.hexdigest(user.id.to_s+user.email)}"
    mail(:to => user.email, :subject => "你好#{user.first} #{user.last}， 感谢您注册助写网")
  end

  def send_forgot_password(user)
    @user = user
    @url  = "#{default_url_options[:host]}/forgot_password/?email=#{user.email}&token=#{Digest::MD5.hexdigest(user.id.to_s+user.password)}"
    puts @url
    mail(:to => user.email, :subject => "助写网找回密码")
  end

  def send_new_task_mail(user,request)
    @user = user
    @request = request
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    mail(:to => user.email, :subject => "你好#{user.first} #{user.last}， 助写网 - 有人发布了一个适合您的任务。报酬:#{request.price}")
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

  def send_taker_accept_mail(user,request)
    @user = user
    @request = request
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    mail(:to => user.email, :subject => "恭喜你！你已经赢得了任务#{request.id}的竞标！")
  end

  def send_taker_validation_mail(user,accept,reason)
    @user = user
    if accept==1
      @subject = "恭喜你！你已经通过了助写网的认证，成为认证承接人！";
      @content = "恭喜你！你已经通过了助写网的认证，成为认证承接人。现在您将可以接受助写网上适合您的任务了。如有适合您的任务，我们将会以Email通知您。";
      @url =  "#{default_url_options[:host]}/"
    elsif accept==0
      @subject = "对不起，您在助写网的审核未能被通过。";
      @content = "对不起，您在助写网的审核未能被通过。原因是: <b>#{reason}</b>如有疑问请回复Email。";
    end
    logger.info "from:hy10121012@hotmail.com :to #{user.email}";
    mail(:to => user.email, :subject =>@subject)
  end


end
