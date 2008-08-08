class AddVoteCountToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :questions, :votes_count
  end
end
