class DropScoreColumn < ActiveRecord::Migration
  def self.up
    remove_column :votes, :score
  end

  def self.down
    add_column :votes, :score, :integer
  end
end
