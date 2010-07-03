class AlterContestsAddLength < ActiveRecord::Migration
  def self.up
    add_column(:contests, :length, :integer, :limit=>3)
  end

  def self.down
    remove_column(:contests, :length)
  end
end
