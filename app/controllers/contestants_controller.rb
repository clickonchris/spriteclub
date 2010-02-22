class ContestantsController < ApplicationController
  
  def new
    
    @contestant = Contestant.new

  end
  
  
  def create
    
    @contestant = Contestant.new(params[:contestant])
    @contestant.contest_id = 1
    @contestant.experience_level =1
    @contestant.total_points =0
    @contestant.save!
    
    redirect_to :action => "show", :id => @contestant.id
  end
  
  def show
        @contestant = Contestant.find(params[:id])
  end
end
