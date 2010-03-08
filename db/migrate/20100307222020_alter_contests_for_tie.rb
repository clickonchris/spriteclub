class AlterContestsForTie < ActiveRecord::Migration
  def self.up
    add_column :contests, :is_a_tie, :boolean
    
    add_column :contestants, :gender, :string, :limit=>1
  end

  def self.down
    remove_column :contests, :is_a_tie
    
    remove_column :contestants, :gender
  end
end
