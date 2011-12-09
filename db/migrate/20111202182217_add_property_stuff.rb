class AddPropertyStuff < ActiveRecord::Migration
  def self.up
    remove_column :data_calendar_events, :public
    remove_column :data_calendar_events, :user_id
    ActiveRecord::Base.connection.tables.select{|t| t =~ /^data_/}.each do |table|
      add_column table, :owner_id, :integer
      add_column table, :public, :boolean, :default => true
    end
  end

  def self.down
    ActiveRecord::Base.connection.tables.select{|t| t =~ /^data_/}.each do |table|
      remove_column table, :owner_id
      remove_column table, :public
    end
    add_column :data_calendar_events, :public, :boolean
    add_column :data_calendar_events, :user_id, :integer
  end
end
