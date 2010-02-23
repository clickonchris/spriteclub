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
    
    @contestant = Contestant.new(params[:contestant])
    @contestant.contests << Contest.find(params[:contest_id])
    @contestant.experience_level =1
    @contestant.total_points =0
    
    @contestant.save!
    
    redirect_to :action => "show", :id => @contestant.id
  end
  
  def show
        @contestant = Contestant.find(params[:id])
  end
end
