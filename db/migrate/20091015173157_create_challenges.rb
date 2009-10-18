class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      t.integer :initiated_by_user_id
      t.integer :sent_to_user_id
      t.string :status
      t.timestamp :expire_date

      t.timestamps
    end
  end

  def self.down
    drop_table :challenges
  end
end
