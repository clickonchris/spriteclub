class AddDeletedAtToContestantAndContest < ActiveRecord::Migration
  def self.up
    add_column :contestants, :deleted_at, :datetime
    add_column :contests, :deleted_at, :datetime
  end

  def self.down
    remove_column :contestants, :deleted_at
    remove_column :contests, :deleted_at
  end
end
