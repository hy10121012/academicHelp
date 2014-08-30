class User < ActiveRecord::Base
  has_one :education
  belongs_to :user_type
  belongs_to :subject_area

  def is_taker?
    self.user_type_id==2
  end

  def get_reputation
    if(user_type_id==1)
      total_count =Request.find_all_by_user_id(id).count;
      if(total_count>0)
        (total_count*10)-(Request.where(user_id: id, is_cancel: 1).count*15).round.to_i
      else
        '--'
      end
    else
      total_count =(RequestAllocation.where(:taker_id=>id, is_success: 1).count+RequestAllocation.where(:taker_id=>id, is_success: nil).count*0.2).round.to_i;
      if(total_count>0)
        (total_count*10)-(RequestAllocation.where(taker_id: id, is_success: 0).count*13)
      else
        '--'
      end
    end


  end

  def request_success
    RequestAllocation.where(taker_id: id, is_success: 1).count
  end

  def request_fail
    RequestAllocation.where(taker_id: id, is_success: 0).count
  end

  def request_complete_rate
    success =  request_success
    fail = request_fail
    if(success+fail>0)
      return  ((success.to_f/(success+fail).to_f)*100).round.to_s+"%"
    else
      return "--"
    end
  end

  def get_rating
    votes = Vote.find_vote(id)
    if((votes[VoteType::POSITIVE]+ votes[VoteType::NATURE]+votes[VoteType::NEGATIVE])>0)
      puts (votes[VoteType::POSITIVE].to_f+votes[VoteType::NATURE]*0.3)
      return ((votes[VoteType::POSITIVE].to_f+votes[VoteType::NATURE]*0.3).to_f/(votes[VoteType::POSITIVE]+ votes[VoteType::NATURE]+votes[VoteType::NEGATIVE] ).to_f*100).round.to_s+"%"
    else
      return "--"
    end
  end


  def self.exist?(email)
    self.where(email: email).count>0
  end




end