class Contest < ActiveRecord::Base
  belongs_to :challenge
  has_many :contestants
  
    after_create :send_challenge_notification
  
  # method to build a challenge based on the supplied attributes
  def challenge_attributes=(challenge_attributes)
    challenge_attributes.each do |attributes|
      build_challenge(attributes)
    end
  end
  
  # method to build contestants based on the supplied attributes
  def contestant_attributes=(contestant_attributes)
    contestant_attributes.each do |attributes|
      contestants.build(attributes)
    end
  end
  
  def send_challenge_notification
    ChallengePublisher.deliver_challenge_notification(self.challenge) 
  rescue Facebooker::Session::SessionExpired
    # We can't recover from this error, but
    # we don't want to show an error to our user
  end
  
  
end
