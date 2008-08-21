class AddActiveQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :active, :boolean,  :null => false, :default => false
  end

  def self.down
    remove_column :questions, :active
  end
end
