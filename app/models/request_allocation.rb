class RequestAllocation < ActiveRecord::Base
  belongs_to :request
  belongs_to :taker, :class_name=>'User', :foreign_key=>'taker_id'

end
