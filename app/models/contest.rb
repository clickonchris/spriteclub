class Contest < ActiveRecord::Base

  has_and_belongs_to_many :contestants
  
  belongs_to :initiated_by_user, 
             :class_name=>'User', 
             :foreign_key=>'initiated_by_user_id'
             
  belongs_to :sent_to_user, 
             :class_name=>'User', 
             :foreign_key=>'sent_to_user_id'
  
  validates_presence_of :initiated_by_user, :sent_to_user
  
  attr_accessor :new_contestant
  
  #after_create :send_challenge_notification

  
  # method to build contestants based on the supplied attributes
  def contestant_attributes=(contestant_attributes)
    contestant_attributes.each do |attributes|
      contestants.build(attributes)
    end
  end
  
#  def send_challenge_notification
#    ChallengePublisher.deliver_challenge_notification(self.challenge) 
#  rescue Facebooker::Session::SessionExpired
##     We can't recover from this error, but
##     we don't want to show an error to our user
#  end

  
end
