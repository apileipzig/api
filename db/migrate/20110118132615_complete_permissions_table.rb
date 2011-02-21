class CompletePermissionsTable < ActiveRecord::Migration
  def self.up
    add_column :permissions, :access, :string
    add_column :permissions, :tabelle, :string
    add_column :permissions, :spalte, :string
    remove_column :permissions, :name
  end

  def self.down
    add_column :permissions, :name, :string
    remove_column :permissions, :access
    remove_column :permissions, :tabelle
    remove_column :permissions, :spalte
  end
end
