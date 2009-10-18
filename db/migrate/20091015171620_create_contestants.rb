class CreateContestants < ActiveRecord::Migration
  def self.up
    create_table :contestants do |t|
      t.integer :contest_id, :null=>false
      t.string :first_name, :limit=>100
      t.string :last_name, :limit=>100
      t.string :middle_name, :limit=>50
      t.column :image_file, :binary, :limit=> 1.megabyte
      t.string :photo_url
      t.integer :total_points
      t.integer :experience_level

      t.timestamps
    end
  end

  def self.down
    drop_table :contestants
  end
end
