class CreateRewards < ActiveRecord::Migration
  def self.up
    create_table :rewards do |t|
      t.string :description, :limit=>512
      t.integer :points
      t.integer :user_id
      t.integer :contestant_id #the contestant this reward is associated with in case we want to revoke all awards for some contestant.  maybe should be many to many

      t.timestamps
    end
  end

  def self.down
    drop_table :rewards
  end
end
