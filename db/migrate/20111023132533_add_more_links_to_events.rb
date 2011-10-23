class AddMoreLinksToEvents < ActiveRecord::Migration
  def self.up
    add_column :data_calendar_events, :image_url, :string
    add_column :data_calendar_events, :document_url, :string
  end

  def self.down
    remove_column :data_calendar_events, :image_url
    remove_column :data_calendar_events, :document_url
  end
end