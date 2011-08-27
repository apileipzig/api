class AddMkwBranchIdToCompanies < ActiveRecord::Migration
  def self.up
    add_column :data_mediahandbook_companies, :mkw_branch_id, :integer
  end

  def self.down
    remove_column :data_mediahandbook_companies, :mkw_branch_id
  end
end