#coding: utf-8
require 'digest/md5'
class MakerMailer < ActionMailer::Base
  before_filter :set_mailer_host

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = "http://zhuxuewang.co.uk"
  end
  default from: "hy10121012@hotmail.com"

  def send_taker_take_task(taker,request)
    @user = User.find(request.user_id)
    @taker = taker
    @request=request
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    @request_count =Request.count_request_by_type_taker(taker.id)
    mail(:to => @user.email, :subject => "用户#{taker.id}申请承接任务: #{request.title}")
  end

  def send_taker_mark_progress(taker,request,process)
    @user = User.find(request.user_id)
    @taker = taker
    @request=request
    @procgress=process
    @url  = "#{default_url_options[:host]}/requests/#{request.id}"
    @request_count =Request.count_request_by_type_taker(taker.id)
    mail(:to => @user.email, :subject => "用户#{taker.id}已经完成任务#{request.title}的#{process}%，请验收")
  end

end
