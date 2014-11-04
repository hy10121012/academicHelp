class Vote < ActiveRecord::Base
  belongs_to :voter, :class_name=>'User', :foreign_key=>'from_user_id'
  belongs_to :user, :class_name=>'User', :foreign_key=>'to_user_id'

  def self.find_vote(user_id)
    votes = where(:to_user_id=>user_id)
    vote_counts = {VoteType::POSITIVE=>0, VoteType::NATURE=>0, VoteType::NEGATIVE=>0}
    logger.info "#{votes.size}--------"
    votes.each do |vote|
      puts "#{VoteType::POSITIVE} - #{vote.vote_type}"
      case vote.vote_type
        when VoteType::POSITIVE
          vote_counts[VoteType::POSITIVE]+=1
        when VoteType::NATURE
          vote_counts[VoteType::NATURE]+=1
        when VoteType::NEGATIVE
          vote_counts[VoteType::NEGATIVE]+=1
      end
    end
    return vote_counts
  end
end
