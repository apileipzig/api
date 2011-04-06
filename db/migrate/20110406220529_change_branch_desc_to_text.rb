class ChangeBranchDescToText < ActiveRecord::Migration
  def self.up
    change_column :data_mediahandbook_branches, :description, :text
  end

  def self.down
    change_column :data_mediahandbook_branches, :description, :string
  end
end
