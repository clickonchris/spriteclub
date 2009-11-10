class Challenge < ActiveRecord::Base
  has_one :contest
  belongs_to :initiated_by_user, 
             :class_name=>'User', 
             :foreign_key=>'initiated_by_user_id'
             
  belongs_to :sent_to_user, 
             :class_name=>'User', 
             :foreign_key=>'sent_to_user_id'
  
  validates_presence_of :initiated_by_user, :sent_to_user
  

  
  
  
  # method to build a contest based on the supplied attributes
  def contest_attributes=(contest_attributes)
    contest_attributes.each do |attributes|
      build_contest(attributes)
    end
  end
  
end
