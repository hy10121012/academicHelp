class RequestAllocation < ActiveRecord::Base
  belongs_to :request
  belongs_to :taker, :class_name=>'User', :foreign_key=>'taker_id'

  def self.awaiting_allocation(request_id)
    where(:request_id=>request_id,:is_approved => nil)
  end

  def get_pay_amount
    (self.request.price*self.request.latest_approved_submit.process/100).floor
  end

end
