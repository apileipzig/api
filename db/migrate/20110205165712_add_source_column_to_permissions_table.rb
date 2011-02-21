class AddSourceColumnToPermissionsTable < ActiveRecord::Migration
  def self.up
    add_column :permissions, :source, :string, :after => :access
  end

  def self.down
    remove_column :permissions, :source
  end
end
