class ContestsController < ApplicationController
  
attr_accessor :intro_text

def index
    
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
       #redirect_to leaders_path and return if @user.nil?
    end
    # If we don't have a user, require add
    if @user.blank?
      ensure_authenticated_to_facebook   
      return 
    end
    
    @contests = Contest.find(:all, :conditions=>{:status=>'IN_PROGRESS'})


end



def new
    @contest = Contest.new
    #@contest.build_challenge
    # @contest.contestants.build
    # @contest.contestants[0].user = @user;
    
    if params[:user_id]
      @user = User.find(params[:user_id])
    end
    
    @contestants = current_user.contestants
    new_contestant_option = Contestant.new()
    new_contestant_option.id =-1
    new_contestant_option.name="Create New Sprite..."
    @contestants.insert(0,new_contestant_option)
    #@options = options_from_collection_for_select(contestants, 'id', 'name', selected = nil)
    
    
    @prompt_permission = true
    
    if current_user.facebook_session.user.has_permission?('publish_stream')
      @prompt_permission = false
    end

end


#
#  When the user saves the contest it will go here.
#  If there is no contestant, redirect the user to create a contestant
#
#
 def create
   
   
    
    if params[:ids].blank?
      flash[:error] = "You forgot to tell me who you wanted to Challenge!"    
      render :action=>"new"
    end
    
    @contest = Contest.new(params[:contest])
    
    #set the initiating user
    @contest.initiated_by_user = current_user;
    
    #params[:ids][0] should be the id of the facebook user we are sending the challenge to
    @contest.sent_to_user = User.for(params[:ids][0])
    
    @contest.status = 'WAITING_FOR_CHALLENGER'
    
    @contest.save!
    
    #set the secret key so we can see it outside of facebook
    current_user.secret_key = current_user.session_key
    current_user.save!
    
    flash[:notice] = "Face-Off created"
    
    if @contest.select_contestant_id == "-1"
        #User selected "Create new sprite..."
        #TODO hash session key so we can compare it with a hashed version on constestant/new
        
        redirect_to :controller=>"ext_contestants",:action=>"new",
                    :canvas=>false,
                    :contest_id=>@contest.id,
                    :user_id=>current_user.id,
                    :key=>current_user.secret_key,
                    :method=>'post'
    else
        #User selected an existing sprite
        @contest.contestants << Contestant.find(@contest.select_contestant_id)

        #send the challenge notification
        @contest.send_challenge_notification
        
        render :action=>'show', :id=>@contest.id
    end


end

def accept
  if params[:user_id]
      @user = User.find(params[:user_id])
  else
      @user = current_user
  end
  
  @contest = Contest.find(params[:id])
  
  #Verify that this is the sent_to_user
  if (@user != @contest.sent_to_user)
    #raise SpriteClubAuthError.new("Only " + @contest.sent_to_user.facebook_session.user.name + " may accept the challenge")
    #flash[:error] = "Only <fb:name uid="+@contest.sent_to_user.facebook_id.to_s+"/> may accept the challenge"
    flash[:error] = "Only the user to whom this challenge was sent may accept"
    logger.error "the current user is NOT the sent to user"
    render :action=>'show'
  end
  
  #TODO: enhance this so that it validates that the user has not already accepted the challenge

  
  #build the new contestant for the sent to user.
  #We need a way to link this contestant directly to the user
  newContestant = @contest.contestants.build
  newContestant.user = @user
  
  @contestants = current_user.contestants
  new_contestant_option = Contestant.new()
  new_contestant_option.id =-1
  new_contestant_option.name="Create New Sprite..."
  @contestants.insert(0,new_contestant_option)
  
  #do some validation to make sure that the user accessing this method is
  #the "sent_to_user"
  if (@user == @contest.sent_to_user)
    logger.info "the current user is the sent to user"
  else
    
  end
  
end

def accept_save
  @contest = Contest.find(params[:id])
  if !@contest.update_attributes(params[:contest])
    throw SpriteClubGenericError.new("Error")
  end

  if @contest.select_contestant_id == "-1"
      #User selected "Create new sprite..."
      #TODO hash session key so we can compare it with a hashed version on constestant/new
      
      #set the secret key so we can see it outside of facebook
      current_user.secret_key = current_user.session_key
      current_user.save!
      
      redirect_to :controller=>"ext_contestants",:action=>"new",
                  :canvas=>false,
                  :contest_id=>@contest.id,
                  :user_id=>current_user.id,
                  :key=>current_user.secret_key,
                  :method=>'post'
  else
      
      @contest.status = 'IN_PROGRESS'
      @contest.start_time = Time.now.utc
      @contest.end_time = @contest.start_time + 60*60*24*7 # end the contest 7 days from now
      @contest.contestants << Contestant.find(@contest.select_contestant_id)
      @contest.save!
      logger.info "Face-Off updated"
      flash[:notice] = "Challenge Accepted"
      
      render :action=>'show'
  end
end


# The method that correlates to viewing of the main contest page
# If the contest is pending, show "waiting for challenger" from the missing
# contestant.

# If the contest is active, show a vote button to any users that haven't voted yet

# If the contest is over, show the contest results and vote totals

#
def show
  if params[:user_id]
      @user = User.find(params[:user_id])
  else
      @user = current_user
  end
  
  @contest = Contest.find(params[:id])
  
  # This will end the contest if it should be ended
  @contest.check_finished?
  
  #for each contestant, show picture, show votes
  
end



  def default_url_options(options)
    {:canvas=>true}
  end
  
  def vote
    
    @contest = Contest.find(params[:id])
    
    #make sure that this user isn't voting twice for the same contest (like in Chicago)
    
    if (current_user.can_vote_on_contest?(@contest.id))
      #need to show how long until the user can vote again
      flash[:error] = "You can only vote on this Face-Off every four hours.  Please come back later"
    end
    
    if @contest.check_finished?
      flash[:error] = "This Face-Off has ended"
    end
    
    
    if flash[:error].blank?
      vote = Vote.new
      vote.user_id = current_user.id
      vote.contest_id = @contest.id
      vote.contestant_id = Contestant.find(params[:contestant_id]).id
      vote.save!
      
      flash[:notice] = "Vote cast successfully.  Come back in 4 hours and vote again!"
    
    end
    
    render :action=>'show'
  end

end
