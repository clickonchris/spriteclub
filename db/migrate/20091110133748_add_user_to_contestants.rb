class AddUserToContestants < ActiveRecord::Migration
  def self.up
    add_column :contestants, :owner_user_id, :integer
  end

  def self.down
    remove_column :contestants, :owner_user_id
  end
end
