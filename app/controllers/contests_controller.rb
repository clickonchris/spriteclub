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
    @contest.build_challenge
    @contest.contestants.build
    @contest.contestants[0].user = @user;

end

 def create
    
    if params[:ids].blank?
      flash[:error] = "You forgot to tell me who you wanted to Challenge!"    
      redirect_to_new_contest_path
    end
    
    @contest = Contest.new(params[:contest])
    
    @contest.build_challenge
    
    #set the initiating user
    @contest.challenge.initiated_by_user = current_user;
    
    #params[:ids][0] should be the id of the facebook user we are sending the challenge to
    @contest.challenge.sent_to_user = User.for(params[:ids][0])
    
    @contest.save!
    
    flash[:notice] = "Challenge sent successfully"
    
    redirect_to :action=>'index'

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
#
def view
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
