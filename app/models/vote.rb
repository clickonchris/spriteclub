class Vote < ActiveRecord::Base
  has_one :contestant
  has_one :user
  has_one :contest
  
end
