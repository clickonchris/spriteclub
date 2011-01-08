class Contestant < ActiveRecord::Base
  has_and_belongs_to_many :contests
  belongs_to :user, :class_name=>'User', :foreign_key=>'owner_user_id'
  has_many :votes
  has_many :ratings
  
  has_many :contests_won,
           :class_name=>'Contest',
           :foreign_key=>'winner_contestant_id'

  
    has_attached_file :photo, 
                  :styles => { :small => "150x150>", :medium => "300x300>" },
                  #:url  => "/assets/contestants/:id/:style/:basename.:extension",
                  :path => ":attachment/assets/contestants/:id/:style/:basename.:extension",
                  :storage => :s3,
                  :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                  :bucket => 'spriteclub-' +Rails.env #eg spriteclub-development, spriteclub-production
  

  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg']
   
   
  #convenience method to tell us how many votes some contestant has for some contest 
  def votes_for_contest(contest_id)
    return Vote.find(:all, :conditions=>{:contestant_id=>id,:contest_id=>contest_id}).size
  end
  
  #virtual attribute to help with our leaderboard query
  def average_score
    attributes['average_score']
  end
  def contests_won
    attributes['contests_won']
  end
  
  def total_contests
    attributes['total_contests']
  end
  
  def average_score_formatted
    return "0.000" if average_score == nil || average_score == 0
    
  end
  
  def ratio
    return "0.000" if total_contests == nil || total_contests == 0
    return sprintf("%.3f",(contests_won.to_f / total_contests.to_f))
  end
  
  # this method will get the next contestant for the user to rank
  # based on the "last" contestant id which is passed in
  # It basically rotates backwards through all of the contestants
  # starting with the newest one.
  def self.get_next_to_rank(last_ranked_id)
    result =  find :first, 
                        :conditions=> ["id < ?", last_ranked_id],
                        :order=> "id DESC"
                 
    if result == nil
      logger.info "next result is nil. starting over from max"
      result = find :first,
                         :order=> "id DESC"
    end
    return result
  end
end
