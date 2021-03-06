class User < ActiveRecord::Base
  has_many :votes
  has_many :challenges_initiated, :class_name=>'Contest', :foreign_key=>'initiated_by_user_id'
  has_many :challenges_received, :class_name=>'Contest', :foreign_key=>'sent_to_user_id'
  has_many :contestants, :class_name=>'Contestant', :foreign_key=>'owner_user_id'
  has_many :rewards
  has_many :ratings
  
  def connected?
    !facebook_id.blank?
  end
  
  def create_user
    User.for(facebook_session.user.to_i)
  end
  
  
  def self.for(access_token, expires, facebook_id)
    u = find_or_create_by_facebook_id(facebook_id)
    
      #logger.info "expiration is" + current_facebook_user.client.expiration.to_s
      u.update_attributes(:access_token=>access_token, 
                          :access_token_expires=>Time.at(expires))
    return u
  end
  
  def self.for_facebook_id(facebook_id)
    u = find_or_create_by_facebook_id(facebook_id)
    return u
  end
  
  
  
  def store_session(session_key)
    if self.session_key != session_key
      update_attribute(:session_key,session_key) 
    end
  end
  
  def facebook_session
    @facebook_session ||=  
      returning Facebooker::Session.create do |session| 
        session.secure_with!(session_key,facebook_id,1.day.from_now) 
        Facebooker::Session.current=session
    end
  end
  
  #convenience method to tell if the user has voted on some contest
  def can_vote_on_contest?(contest_id)
    #find UTC - 24 hours, since thats how its stored in the DB
    yesterday = Time.now.utc - 60*60*4
    user_votes_for_contest = Vote.find(:all,
                                       :conditions=> ["contest_id= :contest_id AND user_id= :user_id AND updated_at > :yesterday",
                                                      {:contest_id=>contest_id, :user_id=>id, :yesterday=>yesterday}])

    if (user_votes_for_contest.size >0) 
      return true
    else
      return false
    end
    
  end
  
  #####  User Rewards Section ####
  
  def reward_points
    return Reward.calculate(:sum,:points,:conditions=> "user_id = " + self.id.to_s)
  end
  
  def reward_for_voting(description)
      reward = Reward.new
      reward.points = 1
      reward.description = description
      reward.user_id = self.id
      reward.save!
  end
  
    def reward_for_rating(description)
      reward = Reward.new
      reward.points = 1
      reward.description = description
      reward.user_id = self.id
      reward.save!
  end
  
  def reward_for_challenging(description)
      reward = Reward.new
      reward.points = 5
      reward.description = description
      reward.user_id = self.id
      reward.save!
  end
  
  def reward_for_accepting(description)
      reward = Reward.new
      reward.points = 10
      reward.description = description
      reward.user_id = self.id
      reward.save!
  end
  
  def reward_for_winning(description, contestant_id)
      reward = Reward.new
      reward.points = 100
      reward.description = description
      reward.user_id = self.id
      reward.contestant_id = contestant_id
      reward.save!
  end
  
  def reward_for_tie(description, contestant_id)
      reward = Reward.new
      reward.points = 50
      reward.description = description
      reward.user_id = self.id
      reward.contestant_id = contestant_id
      reward.save!
  end
  
  def reward_for_getting_challenge_accepted(description)
      reward = Reward.new
      reward.points = 5
      reward.description = description
      reward.user_id = self.id
      reward.save!
  end
  
  def reward_for_creating_contestant(description, contestant_id)
      reward = Reward.new
      reward.points = 30
      reward.description = description
      reward.user_id = self.id
      reward.contestant_id = contestant_id
      reward.save!
  end
  
end
