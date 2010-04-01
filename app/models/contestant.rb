class Contestant < ActiveRecord::Base
  has_and_belongs_to_many :contests
  belongs_to :user, :class_name=>'User', :foreign_key=>'owner_user_id'
  has_many :votes
  
  has_many :contests_won,
           :class_name=>'Contest',
           :foreign_key=>'winner_contestant_id'

  
    has_attached_file :photo, :styles => { :small => "150x150>", :medium => "300x300>" },
                  :url  => "/assets/contestants/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/contestants/:id/:style/:basename.:extension"
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg']
   
   
  #convenience method to tell us how many votes some contestant has for some contest 
  def votes_for_contest(contest_id)
    return Vote.find(:all, :conditions=>{:contestant_id=>id,:contest_id=>contest_id}).size
  end
  
end
