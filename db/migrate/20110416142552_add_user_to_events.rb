class AddUserToEvents < ActiveRecord::Migration
  def self.up
    add_column :data_calendar_events, :user_id, :integer
  end

  def self.down
    remove_column :data_calendar_events, :user_id
  end
end
