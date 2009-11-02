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

  end

  def default_url_options(options)
    {:canvas=>true}
  end

end
