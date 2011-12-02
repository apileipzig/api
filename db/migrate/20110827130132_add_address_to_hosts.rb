class AddAddressToHosts < ActiveRecord::Migration
  def self.up
    add_column :data_calendar_hosts, :company, :string
    add_column :data_calendar_hosts, :street, :string
    add_column :data_calendar_hosts, :housenumber, :integer
    add_column :data_calendar_hosts, :housenumber_additional, :string 
    add_column :data_calendar_hosts, :postcode, :string
    add_column :data_calendar_hosts, :city, :string
    add_column :data_calendar_hosts, :email, :string
    add_column :data_calendar_hosts, :fax, :string
    add_column :data_calendar_hosts, :comment, :text
  end

  def self.down
    remove_column :data_calendar_hosts, :company
    remove_column :data_calendar_hosts, :street
    remove_column :data_calendar_hosts, :housenumber
    remove_column :data_calendar_hosts, :housenumber_additional 
    remove_column :data_calendar_hosts, :postcode
    remove_column :data_calendar_hosts, :city
    remove_column :data_calendar_hosts, :email
    remove_column :data_calendar_hosts, :fax
    remove_column :data_calendar_hosts, :comment    
  end
end