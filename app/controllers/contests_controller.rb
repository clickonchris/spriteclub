class ContestsController < ApplicationController

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
    
    @contests = Contest.find(:all)

#    respond_to do |format|
#      format.html # index.html.erb
#      format.fbml # index.fbml.erb
#      format.xml  { render :xml => @challenges }
#    end
end



def new
    @contest = Contest.new
    #@contest.build_challenge
    # @contest.contestants.build
    # @contest.contestants[0].user = @user;

end


#
#  When the user saves the contest it will go here.
#  If there is no contestant, redirect the user to create a contestant
#
#
 def create
   
   
    
    if params[:ids].blank?
      flash[:error] = "You forgot to tell me who you wanted to Challenge!"    
      redirect_to_new_contest_path
    end
    
    @contest = Contest.new(params[:contest])
    
    #set the initiating user
    @contest.initiated_by_user = current_user;
    
    #params[:ids][0] should be the id of the facebook user we are sending the challenge to
    @contest.sent_to_user = User.for(params[:ids][0])
    
    @contest.status = 'WAITING_FOR_CHALLENGER'
    
    @contest.save!
    
    flash[:notice] = "Contest saved"
    
    if @contest.contestants.empty?
        redirect_to :controller=>"contestants",:action=>"new",
                    :canvas=>false,
                    :contest_id=>@contest.id,
                    :method=>'post'
    else
        #send the challenge notification
        @contest.send_challenge_notification
        
        redirect_to :action=>'index'
    end


end

def accept
  if params[:user_id]
      @user = User.find(params[:user_id])
  else
      @user = current_user
  end
  
  @contest = Contest.find(params[:id])
  
  #build the new contestant for the sent to user.
  #We need a way to link this contestant directly to the user
  newContestant = @contest.contestants.build
  newContestant.user = @user
  
  #do some validation to make sure that the user accessing this method is
  #the "sent_to_user"
  if (@user == @contest.challenge.sent_to_user)
    logger.info "the current user is the sent to user"
  else
    logger.error "the current user is NOT the sent to user"
  end
  
end

def accept_save
  @contest = Contest.find(params[:id])
  
  if(@contest.update_attributes(params[:contest]))
    logger.info "contest updated"
    @contest.save!
    #save is successful
    redirect_to 
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
  
  #for each contestant, show picture, show votes
  
end



  def default_url_options(options)
    {:canvas=>true}
  end

end
