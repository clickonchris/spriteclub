class SessionsController < ActionController::Base
  
  include Facebooker2::Rails::Controller
  
  
  def logout
    reset_session;
  end
  
end
