class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.integer :challenge_id
      t.string :name
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :winner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
