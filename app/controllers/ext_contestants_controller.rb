class ExtContestantsController < ActionController::Base

  class SpriteClubAuthError < StandardError; end
  class SpriteClubGenericError < StandardError; end
  
  def new
    
    #if the user is hitting this method after a post from apps.facebook.com, 
    #they might not yet have a facebook session and will get redirected to
    #www.spriteclub.net
    # In this case we need to automatically establish the facebook session.
    
    @contestant = Contestant.new
    
    #wrap in try/catch?
    @contestant.contests << Contest.find(params[:contest_id])
    
    #New will pass these to Create.
    session[:contest_id] = params[:contest_id]
    session[:secret_key] = params[:key]
    session[:user_id] = params[:user_id]
    

  end
  
  
  def create
    
    #Doing some decent validation here to make sure that 
    #the user isn't trying to pull any funny stuff
    contest = Contest.find(session[:contest_id])
    secret_key = session[:secret_key]
    logger.debug("secret key: " + secret_key)
    user = User.find(session[:user_id])
    
    #TODO: compare hashed versions of these keys
    if (user.secret_key != secret_key)
      raise SpriteClubAuthError.new("Authentication Error.  You cannot edit this contestant.")
    end
    
    #Make sure that the same user isn't adding two sprites accidentally
    contest.contestants.each { |c|
      if (c.user.id == user.id)
        raise SpriteClubGenericError.new("This contest already has a contestant added by you.")
      end
    }

    @contestant = Contestant.new(params[:contestant])
    @contestant.contests << contest
    @contestant.experience_level =1
    @contestant.total_points =0
    @contestant.user = user
    
    @contestant.save!
    

    
    #redirect back to facebook
    redirect_to "http://apps.facebook.com/"+ FACEBOOKER['canvas_page_name'] +"/contests/" + contest.id.to_s + "?prompt_publish_contestant_id=" +@contestant.id.to_s 
    
    #redirect_to :action => "show", :id => @contestant.id, :send_notification=> true
  end
  
end
