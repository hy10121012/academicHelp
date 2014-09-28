class Request < ActiveRecord::Base

  belongs_to :user
  belongs_to :request_type
  belongs_to :subject_area
  has_many :request_allocations
  has_many :request_submits
  has_one :latest_submit, -> { where "is_latest_version=true" }, :class_name => 'RequestSubmit'
  has_one :latest_approved_submit, -> { where("is_approved=true").order("process desc, id desc")}, :class_name => 'RequestSubmit'
  has_one :taker_allocation, -> { where "(is_approved is null or is_approved=true) and (is_success is null or is_success=1)" }, :class_name => 'RequestAllocation'
  has_one :taker, :class_name => 'User', :through => :taker_allocation
  has_many :maker_upload_files, -> { where "is_maker_upload = true and (is_deleted=false or is_deleted is null)" }, :class_name => 'RequestFile'
  has_many :taker_upload_files, -> { where "is_maker_upload = false and (is_deleted=false or is_deleted is null)" }, :class_name => 'RequestFile'

  def is_owner?(user_id)
    self.user_id== user_id
  end

  def self.find_request_for_taker(user_id)
    @requests = Request.joins("left join request_allocations on request_allocations.request_id = requests.id").where("request_allocations.taker_id=#{user_id} ").order("requests.id desc")
  end

  def get_taker_upload_files
    return_files=Array.new
    taker_upload_files.each do |file|
      if file.valid_submit?
        return_files.push(file)
      end
    end
    return_files
  end


  def assign_to_user(user_id)
    transaction do
      request_allocation = RequestAllocation.new;
      request_allocation.request_id = self.id
      request_allocation.taker_id = user_id
      request_log = RequestLog.new
      request_log.user_id = user_id
      request_log.action = RequestAction::APPLY
      request_log.request_id=self.id
      request_log.save
      self.status = RequestStatus::ACCEPTED
      self.save
      request_allocation.save
    end
  end

  def maker_cancel(reason)
    transaction do
      request_log = RequestLog.new
      request_log.user_id = self.user_id
      request_log.action = RequestAction::CANCEL
      request_log.request_id=self.id
      request_log.save
      self.is_cancel = 1
      self.status = RequestStatus::CANCELLED
      self.cancel_reason = reason
      self.save

      if (!self.taker_allocation.nil?)
        self.taker_allocation.is_user_cancelled=1
        self.taker_allocation.save
      end
    end
  end

  def accept_taker(user_id)
    transaction do
      request_log = RequestLog.new
      request_log.user_id = self.user_id
      request_log.action = RequestAction::ACCEPT
      request_log.request_id=self.id
      request_log.value=user_id
      request_log.save
      self.status=RequestStatus::AWAITING_PAYMENT
      self.save

      if (!self.taker_allocation.nil?)
        self.taker_allocation.is_approved=1
        self.taker_allocation.save
      end
    end
  end

  def reject_taker(user_id)
    self.transaction do
      self.status=RequestStatus::SUBMITTED
      self.taker_allocation.is_approved=0
      request_log = RequestLog.new
      request_log.user_id = self.user_id
      request_log.action = RequestAction::REJECT
      request_log.request_id=self.id
      request_log.value=user_id
      request_log.save
      self.taker_allocation.save
      self.save
    end
  end

  def do_pay(payment_token, payerID)

    puts "do_pay :#{payment_token} and #{payerID}"
    self.payerID = payerID
    self.payment_token = payment_token
    @paypal = PaypalInterface.new(self)
    success, details= @paypal.do_express_checkout
    if (success)
      self.transaction do
        request_log = RequestLog.new
        request_log.user_id = self.user_id
        request_log.action = RequestAction::PAY
        request_log.request_id=self.id
        request_log.save
        self.status=RequestStatus::IN_PROCESS
        self.save;
      end
      return true,details
    else
      return false,details
    end
  end

  def create_request
    transaction do
      self.save
      request_log = RequestLog.new
      request_log.user_id = self.user_id
      request_log.action = RequestAction::CREATE
      request_log.request_id=self.id
      request_log.save
    end
    return true
  end

  def mark_as_accepted
    self.status = RequestStatus::COMPLETED
    self.transaction do
      self.save
      request_log = RequestLog.new
      request_log.user_id = self.user_id
      request_log.action = RequestAction::MARK_AS_ACCEPTED
      request_log.request_id=self.id
      request_log.save
    end
  end

  def close_request
    self.status = RequestStatus::CLOSED
    self.taker_allocation.is_success=1
    self.transaction do
      request_log = RequestLog.new
      request_log.user_id = self.user_id
      request_log.action = RequestAction::FINISHED
      request_log.request_id=self.id
      request_log.save
      self.save
      self.taker_allocation.save
    end
    return true
  end

  def taker_cancel(user_id)
    if (self.taker.id == user_id)
      self.status=RequestStatus::SUBMITTED
      self.taker_allocation.is_success=0;
      request_log = RequestLog.new
      request_log.user_id = user_id
      request_log.action = RequestAction::DROPOUT
      request_log.request_id=self.id
      self.transaction do
        self.taker_allocation.save
        self.save
        request_log.save
      end
    end
    return true
  end


  def submit_request

  end

  def self.count_request_by_type_maker(user_id)
    vote_counts = {'create' => 0, 'pay' => 0, 'cancel' => 0}
    requests = where(:user_id=>user_id)
    requests.each do |request|
      vote_counts['create']+=1
      if (request.status==RequestStatus::CANCELLED)
        vote_counts['cancel']+=1
      elsif (request.status==RequestStatus::IN_PROCESS || request.status==RequestStatus::HANDED_IN|| request.status==RequestStatus::CLOSED|| request.status==RequestStatus::ARGUE)
        vote_counts['pay']+=1
      end
    end
    return vote_counts;
  end

  def self.count_request_by_type_taker(user_id)
    vote_counts = {'create' => 0, 'pay' => 0, 'cancel' => 0}
    request_allocations = RequestAllocation.where(:taker_id=>user_id,:is_approved => true)
    request_allocations.each do |request_allocation|
      vote_counts['create']+=1
      if (request_allocation.is_success==false)
        vote_counts['cancel']+=1
      elsif (request_allocation.is_success==true)
        vote_counts['pay']+=1
      end
    end
    puts  vote_counts.inspect
    return vote_counts;
  end


  def self.find_suitable_open_request(user)
    Request.where(subject_area_id: user.subject_area_id, status: RequestStatus::SUBMITTED)
  end

  def get_fee
    SysProperty
  end


end
