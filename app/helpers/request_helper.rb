#coding: utf-8
module RequestHelper

  def get_request_status(requestStaus)
    case requestStaus
      when RequestStatus::DRAFT
        "草稿"
      when RequestStatus::SUBMITTED
        "已提交，等待接受"
      when RequestStatus::ACCEPTED
        "已被接受，等待委托人确认"
      when RequestStatus:: AWAITING_PAYMENT
        "已确认，等待付款"
      when RequestStatus::IN_PROCESS
        "正在进行"
      when RequestStatus::CANCELLED
        "已被取消"
      when RequestStatus::HANDED_IN
        "已交货"
      when RequestStatus::CLOSED
        "交易关闭"
      when RequestStatus::ARGUE
        "任务复议中"
    end
  end

  def get_maker_request_action(request_log)
    request_action =request_log.action
    case request_action
      when RequestAction::CREATE
        content ="你创建了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::APPLY
        content ="用户<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>申请承接任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::ACCEPT
        content = "你接受了承接人<a href='/users/#{request_log.value}'>#{request_log.value}</a>承接任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::REJECT
        content ="你拒绝了承接人<a href='/users/#{request_log.value}'>#{request_log.value}</a>承接任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction:: UPLOAD
        content ="承接人在任务<a href='/requests/#{request_log.value}'>#{request_log.request.title}</a>上传了文件<a href=''>#{request_log.value}</a>"
      when RequestAction::CANCEL
        content ="你取消了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::DROPOUT
        content ="<a href='/users/#{request_log.value}'>#{request_log.value}</a>放弃了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::PAY
        content = "你支付了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>所需酬劳"
      when RequestAction::COMPLETE
        content ="任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>完成"
      when RequestAction::FINISHED
        content = "你关闭了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
    end
    content.html_safe
  end

  def get_taker_request_action(request_log)
    request_action =request_log.action
    case request_action
      when RequestAction::CREATE
        content =""
      when RequestAction::APPLY
        content ="你以申请承接任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::ACCEPT
        content = "发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>接受了你承接任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::REJECT
        content ="发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>拒绝了你承接任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction:: UPLOAD
        content ="你在任务<a href='/requests/#{request_log.value}'>#{request_log.request.title}</a>上传了文件<a href=''>#{request_log.value}</a>"
      when RequestAction::CANCEL
        content ="发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>取消了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::DROPOUT
        content ="你放弃了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::PAY
        content = "发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>支付了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>所需酬劳"
      when RequestAction::COMPLETE
        content ="你以交付任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::FINISHED
        content = "发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>关闭了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
    end
    content.html_safe
  end
end
