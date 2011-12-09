class RemoveTimestampsFromPermissionsUsers < ActiveRecord::Migration
	def self.up
    remove_timestamps :permissions_users
	end

	def self.down
		add_timestamps :permissions_users
	end
end
