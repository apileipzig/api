class AddPersonalInformationFieldsToUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :login
    add_column :users, :name, :string
    add_column :users, :telefon, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :telefon
    add_column :users, :login, :string
  end
end
