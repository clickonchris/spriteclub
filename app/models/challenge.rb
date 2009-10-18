class Challenge < ActiveRecord::Base
  has_one :contest
  belongs_to :initiated_by_user, 
             :class_name=>'User', 
             :foreign_key=>'initiated_by_user_id'
             
  belongs_to :sent_to_user, 
             :class_name=>'User', 
             :foreign_key=>'sent_to_user_id'
  
  validates_presence_of :initiated_by_user, :sent_to_user
  
  after_create :send_challenge_notification
  
  def send_challenge_notification
    ChallengePublisher.deliver_challenge_notification(self) 
  rescue Facebooker::Session::SessionExpired
    # We can't recover from this error, but
    # we don't want to show an error to our user
  end
  
  # method to build a contest based on the supplied attributes
  def contest_attributes=(contest_attributes)
    contest_attributes.each do |attributes|
      build_contest(attributes)
    end
  end
  
end
