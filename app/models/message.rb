class Message < ActiveRecord::Base
  belongs_to :request
  belongs_to :taker, :class_name=>'User', :foreign_key=>'taker_id'
  belongs_to :from_user, :class_name=>'User', :foreign_key=>'from_user_id'
  belongs_to :maker, :class_name=>'User', :foreign_key=>'maker_id'


  def self.find_by_maker_id(user_id)
    self.where("id in (select max(id) from messages where maker_id=#{user_id} group by request_id)")
    .order("messages.created_at desc")
  end

  def self.find_by_taker_id(user_id)
    self.where("id in (select max(id) from messages where request_id in
              (select distinct request_id from request_allocations where taker_id=#{user_id}  and (is_success is null or is_success=1) and (is_user_cancelled is null or is_user_cancelled =0)) group by request_id)")
    .order("messages.created_at desc")
  end


end
