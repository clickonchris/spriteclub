class RatingController < ApplicationController
  layout "application"

  before_filter :set_tab

  def set_tab
    @@selected = "rating"  
  end
  
  ##
  # shows the "next" kid to rank.
  # We store the previously ranked kid in ?session?
  #
  def index
    
    # if we get a specific contestant in the url show that one
    if (params[:contestant_id])
      @contestant = Contestant.find(params[:contestant_id])
      return
    end
    
    if session[:last_ranked_contestant]
      last_ranked_id = session[:last_ranked_contestant]
    else
      last_ranked_id = Contestant.maximum(:id)
    end
    
    @contestant = Contestant.get_next_to_rank(last_ranked_id)
    
    
    
  end

  def rate
    rating = Rating.new(params[:rating])
    rating.user = current_user
    rating.save
    
    current_user.reward_for_rating("rated contestant with id:" + rating.contestant.id.to_s)
    
    @contestant = Contestant.get_next_to_rank(rating.contestant.id)
    
    render :index
  end

end
