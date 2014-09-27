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
      when RequestStatus::AWAITING_PAYMENT
        "已确认，等待付款"
      when RequestStatus::IN_PROCESS
        "正在进行"
      when RequestStatus::CANCELLED
        "已被取消"
      when RequestStatus::HANDED_IN
        "已交货"
      when RequestStatus::CLOSED
        "交易关闭"
      when RequestStatus::COMPLETED
        "任务结束，等待最终结果"
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
      when RequestAction::UPLOAD
        if (request_log.user_id==session[:user_id])
          content ="你在任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>上传了文件<a target='_blank' href='/request_doc/#{request_log.request_id}/#{request_log.value2}_#{request_log.value}'>#{request_log.value}</a>"
        elsif (request_log.request.user_id==request_log.user_id)
          content ="发布人在任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>上传了文件<a target='_blank' href='/request_doc/#{request_log.request_id}/#{request_log.value2}_#{request_log.value}'>#{request_log.value}</a>"
        else
          content ="承接人在任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>上传了文件<a target='_blank' href='/request_doc/#{request_log.request_id}/#{request_log.value2}_#{request_log.value}'>#{request_log.value}</a>"
        end
      when RequestAction::CANCEL
        content ="你取消了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::DROPOUT
        content ="承接人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>放弃了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::PAY
        content = "你支付了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>所需酬劳"
      when RequestAction::MARK_AS_ACCEPTED
        content ="你审核通过了<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>交付的任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::HAND_IN
        content ="任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>完成"
      when RequestAction::SUBMIT_PROCESS
        content ="承接人标记任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>#{request_log.request.latest_submit.process}%完成"
      when RequestAction::APPROVEL_SUBMIT
        content ="你通过了对<a href='/requests/#{request_log.request_id}'> #{request_log.request.title}</a>#{request_log.value}% 进度预览的审查"
      when RequestAction::DECLINE_SUBMIT
        content ="你回绝了对<a href='/requests/#{request_log.request_id}'> #{request_log.request.title}</a>#{request_log.value}% 进度预览的审查"
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
      when RequestAction::UPLOAD
        if (request_log.user_id==session[:user_id])
          content ="你在任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>上传了文件<a target='_blank' href='/request_doc/#{request_log.request_id}/#{request_log.value2}_#{request_log.value}'>#{request_log.value}</a>"
        elsif (request_log.request.user_id==request_log.user_id)
          content ="发布人在任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>上传了文件<a target='_blank' href='/request_doc/#{request_log.request_id}/#{request_log.value2}_#{request_log.value}'>#{request_log.value}</a>"
        else
          content ="承接人在任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>上传了文件<a target='_blank' href='/request_doc/#{request_log.request_id}/#{request_log.value2}_#{request_log.value}'>#{request_log.value}</a>"
        end
      when RequestAction::CANCEL
        content ="发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>取消了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::DROPOUT
        content ="你放弃了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::PAY
        content = "发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>支付了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>所需酬劳"
      when RequestAction::HAND_IN
        content ="你以交付任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::MARK_AS_ACCEPTED
        content ="发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>以审核您交付的任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
      when RequestAction::SUBMIT_PROCESS
        content ="你已标记任务<a href='/requests/#{request_log.request_id}'>#{request_log.request.title}</a>#{request_log.request.latest_submit.process}%完成"
      when RequestAction::APPROVEL_SUBMIT
        content ="<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>通过了你对<a href='/requests/#{request_log.request_id}'> #{request_log.request.title}</a>#{request_log.value}% 进度预览的审查"
      when RequestAction::DECLINE_SUBMIT
        content ="<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>回绝了你对<a href='/requests/#{request_log.request_id}'> #{request_log.request.title}</a>#{request_log.value}% 进度预览的审查"
      when RequestAction::FINISHED
        content = "发布人<a href='/users/#{request_log.user_id}'>#{request_log.user_id}</a>关闭了任务<a href='/requests/#{request_log.request.id}'>#{request_log.request.title}</a>"
    end
    content.html_safe
  end

  def get_submit_request_log_process(request_id)

  end

end
