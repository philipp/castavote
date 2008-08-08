class AddScoreToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :score, :integer
  end

  def self.down
    remove_column :questions, :score
  end
end
