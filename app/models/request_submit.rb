class RequestSubmit < ActiveRecord::Base
  belongs_to :request_file


  def self.request_grouped_submits(request_id)
    where("id in (select max(id) from request_submits where request_id=#{request_id} group by process) ")
  end

  def approve
    self.is_approved=true
    request_log = RequestLog.new
    request_log.request_id=self.request_id
    request_log.user_id=self.user_id
    request_log.action=RequestAction::APPROVEL_SUBMIT
    self.transaction do
      self.save
      request_log.value=self.process
      request_log.save
    end
  end

  def decline
    self.is_approved=false
    request_log = RequestLog.new
    request_log.request_id=self.request_id
    request_log.user_id=self.user_id
    request_log.action=RequestAction::DECLINE_SUBMIT
    self.transaction do
      self.save
      request_log.value=self.process
      request_log.save
    end
  end

end
