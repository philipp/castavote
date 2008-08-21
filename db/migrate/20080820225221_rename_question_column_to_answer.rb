class RenameQuestionColumnToAnswer < ActiveRecord::Migration
  def self.up
    rename_column :votes, :question_id, :answer_id
  end

  def self.down
    rename_column :votes, :answer_id, :question_id
  end
end
