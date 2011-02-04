#TODO: Don't forget to add useful validation rules for real data tables

ActiveRecord::Base.include_root_in_json = false # removes table names in json

class User < ActiveRecord::Base
	has_and_belongs_to_many :permissions
end

class Permission < ActiveRecord::Base
	has_and_belongs_to_many :users
end

class RequestLog < ActiveRecord::Base
end

class Mediahandbook_company < ActiveRecord::Base
	set_table_name "data_mediahandbook_companies"
	belongs_to :sub_market, :class_name => "Branch"
	belongs_to :main_branch, :class_name => "Branch"
	has_and_belongs_to_many :sub_branches, :class_name => "Branch", :limit => 6
	#TODO maybe we need a validation for creating 6 sub_branches max
end

class Mediahandbook_branch < ActiveRecord::Base
	set_table_name "data_mediahandbook_branches"
end

class Mediahandbook_person < ActiveRecord::Base
	belongs_to :mediahandbook_company
end

class TempSync < ActiveRecord::Base
end

