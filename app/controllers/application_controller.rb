# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include Facebooker2::Rails::Controller
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4d95a45fc63dc292a49749954a059cd2'
  before_filter :ensure_authenticated_to_facebook  
  
  class SpriteClubAuthError < StandardError; end
  class SpriteClubGenericError < StandardError; end
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
#  helper_attr :current_user
  
 def ensure_authenticated_to_facebook
   if current_user == nil
     logger.info "current user is nil"
     redirect_to :controller=>'sessions', :action=>'login'
   end
 end
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif current_facebook_user and @current_user.nil?
      @current_user = User.find_by_facebook_id(current_facebook_user.id)
      session[:user_id] = @current_user.id
    end
  end
  
  helper_method :current_user
  
  
#   attr_accessor :current_user
#  before_filter :set_current_user
#  def set_current_user
#    set_facebook_session
#    # if the session isn't secured, we don't have a good user id
#    if facebook_session and 
#       facebook_session.secured? and 
#       !request_is_facebook_tab?
#      self.current_user = User.for(facebook_session.user.to_i,facebook_session) 
#    end
#  end
  
  
end
