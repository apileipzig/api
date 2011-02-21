class CreateTempSync < ActiveRecord::Migration
  def self.up
		create_table :temp_syncs do |t|
			t.text :json
			t.timestamps
		end
  end

  def self.down
		drop_table :temp_syncs
  end
end
