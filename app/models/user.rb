class User < ActiveRecord::Base
  has_many :votes
  has_many :challenges_initiated, :class_name=>'Challenge', :foreign_key=>'initiated_by_user_id'
  has_many :challenges_received, :class_name=>'Challenge', :foreign_key=>'sent_to_user_id'
  has_many :contestants, :class_name=>'Contestants', :foreign_key=>'owner_user_id'
  
  def create_user
    User.for(facebook_session.user.to_i)
  end
  
  def self.for(facebook_id,facebook_session=nil)
    returning find_or_create_by_facebook_id(facebook_id) do |user|
      unless facebook_session.nil?
        user.store_session(facebook_session.session_key) 
      end
    end
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
  
end
