class ContestsController < ApplicationController
  layout "application"
#  before_filter :login_required
  
  attr_accessor :intro_text
  
  #setting this to highlight the "active face-offs" tab
  before_filter :set_tab

  def set_tab
    @@selected = "contests"  
  end

def index
    
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
       #redirect_to leaders_path and return if @user.nil?
   end
   
  begin
    current_facebook_user.fetch
  rescue
    logger.error "failed to lookup facebook user: #{$!}.  Maybe an auth problem"
    top_redirect_to auth_url
    return
  end
   #logger.info "current user is " + current_facebook_user.to_s
   
#    # If we don't have a user, require add
#    if @user.blank?
#      ensure_authenticated_to_facebook   
#      return 
#    end
    
    @contests = Contest.find_active_by_end_time
    
    @recently_ended_contests = Contest.find(:all, 
                                            :limit=>10,
                                            #:joins=>:contestants,
                                            :conditions=>"status = 'FINISHED'", 
                                            :order=> "end_time desc")


end



def new
    @contest = Contest.new
    #@contest.build_challenge
    # @contest.contestants.build
    # @contest.contestants[0].user = @user;
    
#    if params[:user_id]
#      @user = User.find(params[:user_id])
#    end
    
#    logger.info "userID is " + current_user.id
    
    @contestants = current_user.contestants
    
    #@contest_length_options = [{:name => "1 Day",:val=>1},{"name" => "3 Days",:val=>3} ]
#    new_contestant_option = Contestant.new()
#    new_contestant_option.id =-1
#    new_contestant_option.name="Create New Sprite..."
#    @contestants.insert(0,new_contestant_option)
    #@options = options_from_collection_for_select(contestants, 'id', 'name', selected = nil)
    
    
#    @prompt_permission = true
#    
#    if current_user.facebook_session.user.has_permission?('publish_stream')
#      @prompt_permission = false
#    end

end


#
#  When the user saves the contest it will go here.
#  If there is no contestant, redirect the user to create a contestant
#
#
 def create
   
    
    if params[:ids].blank?
      flash[:error] = "You forgot to tell me who you wanted to Challenge!"    
      @contestants = current_user.contestants
      render :action=>"new"
    end
    
    @contest = Contest.new(params[:contest])
    
    #set the initiating user
    @contest.initiated_by_user = current_user;
    
    #params[:ids][0] should be the id of the facebook user we are sending the challenge to
    @contest.sent_to_user = User.for_facebook_id(params[:ids][0])
    
    @contest.status = 'WAITING_FOR_CHALLENGER'
    
    @contest.save!
    
    #different logic depending on the which submit button was pushed
    if params[:submit] == "Submit Challenge"
        #User selected an existing sprite
        @contest.contestants << Contestant.find(@contest.select_contestant_id)
        @contest.save
        
        
        redirect_to :action=>'show', :id=>@contest.id, :prompt_publish_contestant_id=>@contest.select_contestant_id
        flash[:notice] = "Face-Off created"
    elsif params[:submit] == "Create New Sprite"
        #We are redirecting the user to the external site to create a sprite profile
  
        #set the secret key so we can see it outside of facebook
#        current_user.secret_key = current_user.session_key
#        current_user.save!
        
        redirect_to_new_contestant
      
    else
      logger.error "params[:submit] was empty when creating a new sprite.  wtf?"
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
#  new_contestant_option = Contestant.new()
#  new_contestant_option.id =-1
#  new_contestant_option.name="Create New Sprite..."
#  @contestants.insert(0,new_contestant_option)
  
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

  if params[:submit] == "Accept Challenge"
      
      @contest.contestants << Contestant.find(@contest.select_contestant_id)
      @contest.kickoff
      
      @contest.sent_to_user.reward_for_accepting("Accepted challenge: " + @contest.name)
      @contest.initiated_by_user.reward_for_getting_challenge_accepted("Your challenge was accepted: " + @contest.name)
      
      logger.info "Face-Off updated"
      flash[:notice] = "Challenge Accepted"
      
      redirect_to :action=>'show',:id=>@contest.id
  elsif params[:submit] == "Create New Sprite"
      #set the secret key so we can see it outside of facebook
      current_user.secret_key = current_user.session_key
      current_user.save!
      
      redirect_to_new_contestant
  end
end




# The method that correlates to viewing of the main contest page
# If the contest is pending, show "waiting for challenger" from the missing
# contestant.

# If the contest is waiting for challenger and the current user is the challenger, prompt them to accept


# If the contest is active, show a vote button to any users that haven't voted yet

# If the contest is over, show the contest results and vote totals

#
def show
  if params[:user_id]
      @user = User.find(params[:user_id])
  else
      @user = current_user
  end
  
  if params[:show_next] != nil && params[:show_next] =='true'
    @contest = Contest.find_next_active(params[:id])
  else
    @contest = Contest.find(params[:id])
  end
  
  # This will end the contest if it should be ended
  @contest.check_finished?
  
  #This will check if this user should be prompted to accept
  if @contest.status == 'WAITING_FOR_CHALLENGER' && @contest.sent_to_user.id == @user.id
    @prompt_accept_challenge = true
  end
  
  #show the initial challenge popup?
  if params[:prompt_publish_contestant_id]
    logger.info "initial challenge prompt"
    #this is the initial challenge
    @prompt_publish_contestant = Contestant.find(params[:prompt_publish_contestant_id])
    @prompt_publish_to_user_id = @contest.sent_to_user.facebook_id
  end
  
  if @contest.initiated_by_user_id == @user.id || @contest.sent_to_user_id == @user.id
    @users_contestant = @contest.contestant_for_user(@user.id)
  end
  
end

#This method is a poor hack to get around the fact that all requests are coming in as posts
#and I can't find a way to generate a url that contains the "show" action.  For GETS our routing knows that if no
#action is specified then it is show by default.
def view
  logger.info "in view"
  show
  render :action=>'show'
end

def show_next_active(this_id)
  contest
end

#  def default_url_options(options)
#    {:canvas=>true}
#  end
  
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
      contestant = Contestant.find(params[:contestant_id])
      vote.contestant_id = contestant.id
      vote.save!
      
      current_user.reward_for_voting("Voted for " + contestant.name + " in " + @contest.name)
      
      flash[:notice] = "Vote cast successfully.  Come back in 4 hours and vote again!"
    
    end
    
    redirect_to :action=>'show', :next_faceoff_link=>true
  end
  
  private
  
  def redirect_to_new_contestant
      redirect_to :controller=>"contestants",:action=>"new",
                :canvas=>false,
                :contest_id=>@contest.id,
                :user_id=>current_user.id,
                :key=>current_user.secret_key,
                :method=>'post'
  end

end
