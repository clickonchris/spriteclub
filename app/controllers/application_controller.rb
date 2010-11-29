# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include Facebooker2::Rails::Controller
  
  helper :all # include all helpers, all the time
  
  @@selected = ""
  
  helper_method :selected
  
  def selected
    @@selected
  end

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
  
  #each time a user visits apps.facebook.com/spriteclub, we will refresh their access token
  def ensure_authenticated_to_facebook
    #1 - check for a active token in the signed request
    #2 - check for a user in the session (how do we know if the facebook session is valid?)
    #3 - nothing worked.  make them login to facebook
    
     top_redirect_to login_url if current_user == nil
  end
  
  def current_user
   if session[:facebook_id]
     @current_user ||= User.find_by_facebook_id(session[:facebook_id])
   elsif current_facebook_user and @current_user.nil?
      @current_user = User.find_by_facebook_id(current_facebook_user.id)
      session[:facebook_id] = current_facebook_user.id
    else
      logger.info "current user is nil"
      @current_user = nil
    end
  end
  
  #creates the oauth url for the user to request authorize and authenticate to spriteclub
  # more details on the scope and display options can be found here:
  # http://developers.facebook.com/docs/authentication/
  def login_url
    authenticator.authorize_url(:scope => 'publish_stream,email', :display => 'page')
  end
  
  def authenticator
    # by redirecting back to HTTP_REFERER, we will go back to the the apps.facebook.com request!
    @authenticator ||= Mogli::Authenticator.new(Facebooker2.app_id, 
                                         Facebooker2.secret, 
                                         @_request.env['HTTP_REFERER']+'/')
  end
  
  # Redirects the top window to the given url if the content is in an iframe, otherwise performs 
  # a normal redirect_to call. 
  def top_redirect_to(url)
      render :layout => false, :inline => '<html><head><script type="text/javascript">window.top.location.href = '+
                                            url.to_json+
                                            ';</script></head></html>'
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
