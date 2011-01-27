class CreateRequestLog < ActiveRecord::Migration
  def self.up
		create_table :request_logs do |t|
			t.string		:api_key
			t.string		:ip						#the ip of the request
			t.string		:dataset			#the dataset which the request applies to
			t.string		:model				#the model which the request applies to
			t.string		:request_path	#the path of the request
			t.string		:query_string	#the parameters of the request
			t.datetime	:created_at, :default => Time.now
		end	
  end

  def self.down
		drop_table :requestlogs
  end
end

