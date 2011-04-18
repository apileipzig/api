class AddUserToEvents < ActiveRecord::Migration
  def self.up
    add_column :data_calendar_events, :public, :boolean
  end

  def self.down
    remove_column :data_calendar_events, :public
  end
end
