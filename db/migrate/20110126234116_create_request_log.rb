class CreateRequestLog < ActiveRecord::Migration
  def self.up
		create_table :request_logs do |t|
			t.string		:api_key
			t.string		:ip						#the ip of the request
			t.string		:source				#the datasource which the request applies to
			t.string		:model				#the model which the request applies to
			t.string		:request_path	#the path of the request
			t.string		:query_string	#the parameters of the request
			t.string		:method				#get,post,put,delete
			t.datetime	:created_at
		end
  end

  def self.down
		drop_table :request_logs
  end
end


