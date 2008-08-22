class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :answers, :question_id
    add_index :companies, :name
    add_index :events, :company_id
    add_index :questions, :event_id
    add_index :votes, :user_id
    add_index :votes, :answer_id
  end

  def self.down
    remove_index :answers, :question_id
    remove_index :companies, :name
    remove_index :events, :company_id
    remove_index :questions, :event_id
    remove_index :votes, :user_id
    remove_index :votes, :answer_id
  end
end
