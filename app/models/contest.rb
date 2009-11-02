class Contest < ActiveRecord::Base
  belongs_to :challenge
  has_many :contestants
  
  
  
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
  
  
end
