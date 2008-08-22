class DropScoreColumnFromQuestion < ActiveRecord::Migration
  def self.up
      remove_column :questions, :score
    end

    def self.down
      add_column :questions, :score, :integer
  end
end
