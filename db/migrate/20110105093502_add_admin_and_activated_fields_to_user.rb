class AddAdminAndActivatedFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean
    add_column :users, :active, :boolean
  end

  def self.down
    remove_column :users, :admin
    remove_column :users, :active
  end
end
