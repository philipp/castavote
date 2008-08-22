class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.references :company, :null => false
      t.references :user, :null => false

      t.timestamps
    end
    add_index :profiles, [:company_id, :user_id], :unique => true
    add_index :profiles, :company_id
    add_index :profiles, :user_id
  end

  def self.down
    remove_index :profiles, [:company_id, :user_id]
    remove_index :profiles, :company_id
    remove_index :profiles, :user_id
    
    drop_table :profiles
  end
end
