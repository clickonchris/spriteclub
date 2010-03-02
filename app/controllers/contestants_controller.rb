class ContestantsController < ApplicationController
  
  def new
    
    @contestant = Contestant.new
    
    #wrap in try/catch?
    @contestant.contests << Contest.find(params[:contest_id])
    
    contest_id = params[:contest_id]

  end
  
  
  def create
    
    #TODO: need to do some decent validation here to make sure that 
    #the user isn't trying to pull any funny stuff
    
    contest = Contest.find(params[:contest_id])
    
    @contestant = Contestant.new(params[:contestant])
    @contestant.contests << contest
    @contestant.experience_level =1
    @contestant.total_points =0
    
    @contestant.save!
    
    #send the challenge notification
    #this might not work from this page?
    #contest.send_challenge_notification
    
    #redirect back to facebook, then send the challenge!
    redirect_to "http://apps.facebook.com/spriteclub/contestants/" + @contestant.id.to_s + "?send_notification=true&contest_id="+ params[:contest_id]
    
    #redirect_to :action => "show", :id => @contestant.id, :send_notification=> true
  end
  
  def show
        @contestant = Contestant.find(params[:id])
        
        if params[:send_notification] == 'true' && params[:contest_id] != ""
          contest = Contest.find(params[:contest_id])
          contest.send_challenge_notification
        end
  end
end
