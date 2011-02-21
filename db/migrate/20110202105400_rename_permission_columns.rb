class RenamePermissionColumns < ActiveRecord::Migration
  def self.up
    rename_column :permissions, :tabelle, :table
    rename_column :permissions, :spalte, :column
  end

  def self.down
    rename_column :permissions, :table, :tabelle
    rename_column :permissions, :column, :spalte
  end
end
