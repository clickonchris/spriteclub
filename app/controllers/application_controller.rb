# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include Facebooker2::Rails::Controller
  
  helper :all # include all helpers, all the time
  
  @@selected = ""
  
  helper_method :selected
  helper_method :current_user
  helper_method :auth_url
  helper_method :top_redirect_to
  
  def selected
    @@selected
  end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4d95a45fc63dc292a49749954a059cd2'
  before_filter :set_p3p
  before_filter :ensure_authenticated_to_facebook
  
  class SpriteClubAuthError < StandardError; end
  class SpriteClubGenericError < StandardError; end
  
  #each time a user visits apps.facebook.com/spriteclub, we will refresh their access token
  #1 - check for a user_id from the signed_request
  #2 - check the session for an active user
  #3 - nothing worked.  redirect to the auth page.
  def ensure_authenticated_to_facebook
    if facebook_params[:user_id]     
      logger.info "User succesfully authenticated. expires: " + facebook_params[:expires].to_s
      fb_create_user_and_client(facebook_params[:oauth_token], facebook_params[:expires], facebook_params[:user_id])
      #I don't like having to rely on current_facebook_user here
      @current_user = User.for(facebook_params[:oauth_token], facebook_params[:expires], facebook_params[:user_id])
      session[:facebook_id] = @current_user.facebook_id
    elsif session[:facebook_id]
      @current_user = User.find_by_facebook_id(session[:facebook_id])
      
      #make sure the auth token we have is still valid  (I think facebooker2 provides this somehow already but I can't find it)
      logger.info "token expires: " + @current_user.access_token_expires.to_s
      if @current_user.access_token_expires == nil  || (@current_user.access_token_expires != nil && @current_user.access_token_expires.utc < Time.now.utc)
        top_redirect_to auth_url
      end
      
      fb_create_user_and_client(@current_user.access_token, @current_user.access_token_expires, @current_user.facebook_id)
      
    #elsif "cookie found"  #A fbs_<app_id> cookie is another way to check for a user.  implement me!
    else
      logger.info "no auth token, session, or cookie found."
      top_redirect_to auth_url
    end
  end
  
  #creates the oauth url for the user to request authorize and authenticate to spriteclub
  # more details on the scope and display options can be found here:
  # http://developers.facebook.com/docs/authentication/
  def auth_url
    url = authenticator.authorize_url(:scope => 'publish_stream,email', :display => 'page')
    logger.info "redirecting to " + url
    return url
  end
  
  def authenticator
    # by redirecting back to HTTP_REFERER, we will go back to the the apps.facebook.com request!
    @authenticator ||= Mogli::Authenticator.new(Facebooker2.app_id, 
                                         Facebooker2.secret, 
                                         @_request.env['HTTP_REFERER'])
  end
  
  # Redirects the top window to the given url if the content is in an iframe, otherwise performs 
  # a normal redirect_to call. 
  def top_redirect_to(url)
      render :layout => false, :inline => '<html><head><script type="text/javascript">window.top.location.href = '+
                                            url.to_json+
                                            ';</script></head></html>'
  end


  def current_user
    @current_user
  end
  
  
#we need to set this p3p privacy policy header or facebook connect will never work on IE
def set_p3p
   response.headers["P3P"]='CP="CAO PSA OUR"'
end
  
  
end
