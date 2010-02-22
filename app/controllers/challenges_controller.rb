class ChallengesController < ApplicationController
  # GET /challenges
  # GET /challenges.xml
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
    
    @challenges = Challenge.find(:all)

#    respond_to do |format|
#      format.html # index.html.erb
#      format.fbml # index.fbml.erb
#      format.xml  { render :xml => @challenges }
#    end
  end

  # GET /challenges/1
  # GET /challenges/1.xml
  def show
    @challenge = Challenge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @challenge }
    end
  end

  # GET /challenges/new
  # GET /challenges/new.xml
  def new
    @challenge = Challenge.new
    #@challenge.build_contest unless @challenge.contest

  end

  # GET /challenges/1/edit
  def edit
    @challenge = Challenge.find(params[:id])
  end
  

  def create
    
    if params[:ids].blank?
      flash[:error] = "You forgot to tell me who you wanted to Challenge!"    
      redirect_to_new_challenge_path
    end
    
    @challenge = Challenge.new(params[:challenge])
    
    #set the initiating user
    @challenge.initiated_by_user = current_user;
    
    #params[:ids][0] should be the id of the facebook user we are sending the challenge to
    @challenge.sent_to_user = User.for(params[:ids][0])
    
    @challenge.save!

  end

  # PUT /challenges/1
  # PUT /challenges/1.xml
  def update
    @challenge = Challenge.find(params[:id])

    respond_to do |format|
      if @challenge.update_attributes(params[:challenge])
        flash[:notice] = 'Challenge was successfully updated.'
        format.html { redirect_to(@challenge) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @challenge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.xml
  def destroy
    @challenge = Challenge.find(params[:id])
    @challenge.destroy

    respond_to do |format|
      format.html { redirect_to(challenges_url) }
      format.xml  { head :ok }
    end
  end
  
  def default_url_options(options)
    {:canvas=>true}
  end
  
  
end
