class CreateContestants < ActiveRecord::Migration
  def self.up
    create_table :contestants do |t|
      t.integer :contest_id, :null=>false
      t.string :name, :limit=>200
      t.integer :total_points
      t.integer :experience_level

      t.timestamps
    end
  end

  def self.down
    drop_table :contestants
  end
end
