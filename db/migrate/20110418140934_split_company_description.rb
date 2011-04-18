class SplitCompanyDescription < ActiveRecord::Migration
  def self.up
    rename_column :data_mediahandbook_companies, :description, :main_activity
    add_column    :data_mediahandbook_companies, :products, :text
    add_column    :data_mediahandbook_companies, :resources, :text
    add_column    :data_mediahandbook_companies, :past_customers, :text
  end

  def self.down
    rename_column :data_mediahandbook_companies, :main_activity, :description
    remove_column :data_mediahandbook_companies, :products
    remove_column :data_mediahandbook_companies, :resources
    remove_column :data_mediahandbook_companies, :past_customers
  end
end
