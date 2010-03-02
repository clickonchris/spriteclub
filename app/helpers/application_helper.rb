# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def challenge_info(contest)
    "thinks their kid is better looking than your kid, and has issued you a challenge: "  + (contest != nil ? contest.name : "un-named challenge")
    
  end
  
end
