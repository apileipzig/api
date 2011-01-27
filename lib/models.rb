ActiveRecord::Base.include_root_in_json = false # removes table names in json

class User < ActiveRecord::Base
	has_and_belongs_to_many :permissions
end

class Permission < ActiveRecord::Base
	has_and_belongs_to_many :users
end

class RequestLog < ActiveRecord::Base
end

class Company < ActiveRecord::Base
	set_table_name "data_companies"
end

class Branch < ActiveRecord::Base
	set_table_name "data_branches"
end

class Person < ActiveRecord::Base
end

