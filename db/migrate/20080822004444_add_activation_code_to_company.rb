class AddActivationCodeToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :joining_code, :string
    add_index :companies, :joining_code
  end

  def self.down
    remove_index :companies, :joining_code
    remove_column :companies, :joining_code
  end
end
