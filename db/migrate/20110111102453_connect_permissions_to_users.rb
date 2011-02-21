class ConnectPermissionsToUsers < ActiveRecord::Migration
  def self.up
    create_table :permissions_users, :id => false do |t|
      t.references :permission
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions_users
  end
end
