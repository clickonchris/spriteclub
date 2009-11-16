class Contestant < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user, :class_name=>'User', :foreign_key=>'owner_user_id'
  has_many :votes
  
  
end
