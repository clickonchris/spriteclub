# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def challenge_info(contest)
    "thinks their kid is better looking than your kid, and has issued you a challenge: "  + (contest != nil ? contest.name : "un-named challenge")
    
  end
  
  def image_url(source) 
   abs_path = image_path(source) 
   unless abs_path =~ /\Ahttp/ 
     abs_path = "http#{'s' if https?}://#{host_with_port}/#{abs_path}" 
   end 
   abs_path 
  end

  def absolute_url(path)
      request.protocol + request.host_with_port + path
  end
  
end
