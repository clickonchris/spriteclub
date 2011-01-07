class LeaderboardController < ApplicationController
  layout "application"
  
    before_filter :set_tab

  def set_tab
    @@selected = "leaderboard"  
  end
  
  def index

          
          #also join with contestants_contests and contests to find the total finished contests per contestant
          #Then, the losses are the total contests - contests won
          #then we can compute win/loss ratio
          #this query is tested working on mysql and postgresql
          sql = "select contestants.id, contestants.name, count(contestants.id) as contests_won, finished_contests.total_contests  " + 
                  "FROM contestants, contests, " + 
                        #subquery to get a list of total finished contests per contestant
                  "    (select contestants.id contestant_id, count(contestants.id)total_contests " + 
                  "    FROM contestants, contestants_contests cc, contests all_contests  " + 
                  "    WHERE contestants.id = cc.contestant_id " + 
                  "    AND cc.contest_id = all_contests.id " + 
                  "    AND all_contests.status = 'FINISHED' " + 
                  "    GROUP BY contestants.id) as finished_contests " + 
                  "WHERE contestants.id = contests.winner_contestant_id  " + 
                  "and contestants.id = finished_contests.contestant_id " + 
                  "GROUP BY contestants.id,contestants.name,total_contests " + 
                  "ORDER BY contests_won DESC "
                  
      @leaderboard = Contestant.find_by_sql(sql)
    
  end
  
end