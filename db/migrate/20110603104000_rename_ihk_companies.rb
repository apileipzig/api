class RenameIhkCompanies < ActiveRecord::Migration
  def self.up
	rename_table :data_district_companies, :data_district_ihkcompanies
  end

  def self.down
	rename_table :data_district_ihkcompanies, :data_district_companies
  end
end
