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
          sql = "Select contestants.id, contestants.name, average_ratings.average_score, win_totals.wins as contests_won, finished_contests.total_contests    
                  FROM contestants 
                    --get the average rating per contestant
                    LEFT OUTER JOIN
                      (SELECT contestant_id, avg(score) as average_score
                      FROM ratings
                      GROUP BY contestant_id) as average_ratings
                    ON contestants.id = average_ratings.contestant_id
                    --get the list of wins per contestant
                    LEFT OUTER JOIN
                      (SELECT contestants.id as contestant_id, count(contestants.id) as wins 
                      FROM contestants JOIN contests on contestants.id = contests.winner_contestant_id
                      GROUP BY contestants.id) as win_totals
                    ON contestants.id = win_totals.contestant_id
                      --get a list of total finished contests per contestant
                    LEFT OUTER JOIN
                      (SELECT contestants.id as contestant_id, count(contestants.id) as total_contests   
                      FROM contestants, contestants_contests cc, contests all_contests    
                      WHERE contestants.id = cc.contestant_id   
                      AND cc.contest_id = all_contests.id   
                      AND all_contests.status = 'FINISHED'   
                      GROUP BY contestants.id) as finished_contests
                    ON contestants.id = finished_contests.contestant_id
                  ORDER BY average_score DESC NULLS LAST"
                                  
      @leaderboard = Contestant.find_by_sql(sql)
      
    
  end
  
end