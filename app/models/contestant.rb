class Contestant < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user, :class_name=>'User', :foreign_key=>'owner_user_id'
  has_many :votes
  
    has_attached_file :photo, :styles => { :small => "150x150>", :medium => "300x300>" },
                  :url  => "/assets/contestants/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/contestant/:id/:style/:basename.:extension"

validates_attachment_presence :photo
validates_attachment_size :photo, :less_than => 1.megabytes
validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
 
  
end
