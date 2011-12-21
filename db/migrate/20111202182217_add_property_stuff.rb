class AddPropertyStuff < ActiveRecord::Migration
  def self.up
    remove_column :data_calendar_events, :public
    remove_column :data_calendar_events, :user_id
    add_column :data_calendar_events, :owner_id, :integer
    add_column :data_calendar_events, :public, :boolean, :default => true
  end

  def self.down
    remove_column table, :owner_id
    remove_column table, :public
    add_column :data_calendar_events, :public, :boolean
    add_column :data_calendar_events, :user_id, :integer
  end
end
