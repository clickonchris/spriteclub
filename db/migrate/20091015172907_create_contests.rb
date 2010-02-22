class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :name
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :winner_contestant_id
      
      t.integer :initiated_by_user_id
      t.integer :sent_to_user_id
      t.string :status
      t.timestamp :expire_date

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
