class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user
      t.references :question
      t.integer :score

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
