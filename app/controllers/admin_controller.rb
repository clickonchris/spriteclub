class AdminController < ApplicationController
  
  def remove_contestants
    @contestants = Contestant.find :all
  end

  #(soft) delete a contestant and their associated contests
  def destroy_contestant
    contestant = Contestant.find(params[:contestant_id])
    contestant.contests.each {|contest|
      contest.destroy
    }
    contestant.destroy
    
    flash[:notice] = "Contestant deleted"
    redirect_to :action=>"remove_contestants"
  end



end
