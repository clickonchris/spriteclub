# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def challenge_info(challenge)
    "A Challenge has been issued:" + (challenge.contest ? challenge.contest.name : "")
  end
  
end
