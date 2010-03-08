class Contest < ActiveRecord::Base

  has_and_belongs_to_many :contestants
  has_many :votes
  
  belongs_to :initiated_by_user, 
             :class_name=>'User', 
             :foreign_key=>'initiated_by_user_id'
             
  belongs_to :sent_to_user, 
             :class_name=>'User', 
             :foreign_key=>'sent_to_user_id'
             
  belongs_to :winner,
             :class_name=>'Contestant',
             :foreign_key=>'winner_contestant_id'
  
  validates_presence_of :initiated_by_user, :sent_to_user
  
  attr_accessor :select_contestant_id, :results
  
  # Lets define the statuses for a contest:
  #  WAITING_FOR_CHALLENGER - waiting to be accepted
  #  IN_PROGRESS - accepted and active
  #  FINISHED - 
  #  EXPIRED - never accepted and past the expire date
  
  #after_create :send_challenge_notification

  
  # method to build contestants based on the supplied attributes
  def contestant_attributes=(contestant_attributes)
    contestant_attributes.each do |attributes|
      contestants.build(attributes)
    end
  end
  
  
  def send_challenge_notification
    ChallengePublisher.deliver_challenge_notification(self) 
  rescue Facebooker::Session::SessionExpired
    #     We can't recover from this error, but
    #     we don't want to show an error to our user
    #   Log it!
  end
  
  
  def kickoff
    self.status = 'IN_PROGRESS'
    self.start_time = Time.now.utc
    self.end_time = Time.now.utc + 60*60*24*7 # 7 days
    self.save
    
  end
  
  
  # A check to see if the contest is over, or if it supposed to be over.  
  # If it is supposed to be over we will end it here
  def check_finished?
    if status == 'IN_PROGRESS' && Time.now.utc >= end_time
      #The contest is supposed to have ended.  We will end it now.
      end_contest
      return true
    elsif status == 'FINISHED' || status == 'EXPIRED'
      return true
    else
      return false
    end
  end
  
  
  # Do all of the clean up work associated with ending a contest.
  # figure out the winner.  Update statuses, etc
  def end_contest
    self.status = 'FINISHED'
    
    #count the votes and declare a winner
    self.winner = nil
    self.is_a_tie = false
    
    #this algorithm assumes two contestants
    contestants.each { |contestant|
      if winner == nil
        self.winner = contestant
      elsif contestant.votes_for_contest(id) > winner.votes_for_contest(id)
        self.winner = contestant
      elsif contestant.votes_for_contest(id) == winner.votes_for_contest(id)
        #its a tie

        self.is_a_tie = true
        self.winner = nil
      end
    }
    
    self.save!
    
    if is_a_tie
      logger.info "contest ID " + id.to_s + " Result: Its a Tie!"
    else
      logger.info "contest ID " + id.to_s + " Result: winner is contestant ID " + winner.id.to_s + ", " + winner.name
    end
  end
  
  def result_text
    if results == nil
      if is_a_tie
        self.results = "Tie!"
      elsif !winner == nil
        self.results = "Winner: " + winner.name + "!"
      else
        self.results = "Results inconclusive"
      end
    end
    
    return self.results
  end

  
end
