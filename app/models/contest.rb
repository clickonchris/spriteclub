class Contest < ActiveRecord::Base
  belongs_to :challenge
  has_many :contestants
  
  
  
  
end
