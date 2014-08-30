class RequestLog < ActiveRecord::Base
  belongs_to :request

  def self.find_maker_logs_by_user_id(user_id)
    self.joins("left join requests on requests.id = request_logs.request_id ").where("requests.user_id=#{user_id}").order("request_logs.created_at desc")
  end
  def self.find_taker_logs_by_user_id(user_id)
    self.where("request_logs.request_id in (select id from request_allocations where taker_id = #{user_id})").order("request_logs.created_at desc")
  end



end