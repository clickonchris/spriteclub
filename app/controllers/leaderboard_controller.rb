class LeaderboardController < ApplicationController
  layout "application"
  
  @@selected = "leaderboard"
  
  def index
    @leaderboard = Contestant.find_by_sql( "select contestants.id, contestants.name, count(contestants.id) as contests_won " +
          "FROM contestants, contests " +
          "WHERE contestants.id = contests.winner_contestant_id " +
          "GROUP BY contestants.id " +
          "ORDER BY contests_won DESC")
    
  end
  
end