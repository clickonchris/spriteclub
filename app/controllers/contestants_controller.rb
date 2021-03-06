class ContestantsController < ApplicationController
  layout "application"
  
  before_filter :set_tab

  def set_tab
    @@selected = "contestants"  
  end
  
  def index
    #show all contestants for the currently logged in user

    
    @contestants = Contestant.find(:all, :conditions=>[ "owner_user_id = ?", current_user.id])
    
  end
  
  def new
    
    #we should be hitting this page from the contests.new page. This is the second step in creating a contest
    
    @contestant = Contestant.new
    
    #wrap in try/catch?
    @contestant.contests << Contest.find(params[:contest_id]) if params[:contest_id]
    
    #session[:user_id] = params[:user_id]
  end
  
  
  def create
    
    logger.info 'bucket is spriteclub-' + Rails.env
    @contest_id = params[:contest][:id]
    @contestant = Contestant.new(params[:contestant])

    @contestant.experience_level =1
    @contestant.total_points =0
    @contestant.user = current_user

    if @contestant.save
    
      

      render :action=>"crop"
    else
      render :action=>"new"
    end
    
    #redirect_to :action => "show", :id => @contestant.id, :send_notification=> true
  end
  
  # This method will get invoked after the cropping screen
  def update
    @contestant = Contestant.find(params[:contestant][:id])
    
    # if there is a contest id we will link this contestant to the contest
    if (params[:contest][:id] != nil && params[:contest][:id] != "" )
      logger.info "contest_id is " + params[:contest][:id]
      contest = Contest.find(params[:contest][:id])
      
      #Make sure that the same user isn't adding two sprites accidentally
      contest.contestants.each { |c|
        if (c.user.id == current_user.id)
          raise SpriteClubGenericError.new("This contest already has a contestant added by you.")
        end
      }
      @contestant.contests << contest
    end
    
    #saves the contestant.  updated attributes include cropping parameters.  This will crop the photo
    if @contestant.update_attributes(params[:contestant])
      if params[:contestant][:photo].blank?
        flash[:notice] = "Successfully updated contestant."
        
        current_user.reward_for_creating_contestant("Created Sprite: " + @contestant.name, @contestant.id)

        #now figure out where to redirect the user based on the scenario

        #redirect the user to the right place if we have created a contest
        if (params[:contest][:id] != nil && params[:contest][:id] != "" )
          #check if this is the user which is accepting the challenge
          if contest.sent_to_user_id == current_user.id
            contest.kickoff
            current_user.reward_for_accepting("Accepted challenge: " + contest.name)
            redirect_to "/contests/" + contest.id.to_s and return
          end
          #redirect back to contest page
          redirect_to "/contests/" + contest.id.to_s + "?prompt_publish_contestant_id=" +@contestant.id.to_s and return
        else
          # create new sprite
          redirect_to "/rating?contestant_id= " + @contestant.id.to_s and return
        end
        # create new challenge
        # accept challenge
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end
  end
  
  def show
  
      @contestant = Contestant.find(params[:id])
      
      #Active Contests
      @pending_contests = []
      @active_contests = []
      @recent_contests = []
      @wins=0.0
      @losses=0.0
      @ties=0.0
      @wlRatio=1.0
      @contestant.contests.each do |contest|
        if contest.status == 'WAITING_FOR_CHALLENGER'
          @pending_contests << contest
        elsif contest.status == 'IN_PROGRESS'
          @active_contests << contest
        elsif contest.status == 'FINISHED'
          @recent_contests << contest
          if contest.is_a_tie
            @ties +=1
          elsif contest.winner != nil && contest.winner == @contestant
            @wins +=1
          else
            @losses +=1
          end
        end
      end
      
      #build the statistics ?? For each contest? votes for,votes against

      #W/L ratio
      if @losses == 0 #avoid divide by zero errors
        @wlRatio = 1
      else
        @wlRatio= @wins/(@wins+@losses)
        logger.info "ratio is " + @wlRatio.to_s
      end
  end
  
  def associate_with_contest

  end
end
