# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4d95a45fc63dc292a49749954a059cd2'
  ensure_authenticated_to_facebook  
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  helper_attr :current_user
  
  attr_accessor :current_user
  before_filter :set_current_user
  
  def set_current_user
    set_facebook_session
    # if the session isn't secured, we don't have a good user id
    if facebook_session and 
       facebook_session.secured? and 
       !request_is_facebook_tab?
      self.current_user = User.for(facebook_session.user.to_i,facebook_session) 
    end
  end
  
end
