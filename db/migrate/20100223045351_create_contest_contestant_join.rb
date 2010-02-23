class CreateContestContestantJoin < ActiveRecord::Migration
  def self.up
    create_table 'contestants_contests', :id=>false do |t|
      t.column :contest_id, :integer
      t.column :contestant_id, :integer
    end
  end

  def self.down
    drop_table 'contestants_contests'
  end
end
