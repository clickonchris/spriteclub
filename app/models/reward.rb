class Reward < ActiveRecord::Base
  has_one :user
  has_one :contestant
end
