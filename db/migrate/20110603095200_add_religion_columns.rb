class AddReligionColumns < ActiveRecord::Migration
  def self.up
  	add_column :data_district_statistics, :religion_protestant, :integer, :after=>"family_status_unknown"
  	add_column :data_district_statistics, :religion_catholic, :integer, :after=>"religion_protestant"
  	add_column :data_district_statistics, :religion_other_or_none, :integer, :after=>"religion_catholic"
  end

  def self.down
  	remove_column :data_district_statistics, :religion_protestant
  	remove_column :data_district_statistics, :religion_catholic
  	remove_column :data_district_statistics, :religion_other_or_none
  end
end
