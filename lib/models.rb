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

class TempSync < ActiveRecord::Base
end

##############
#Mediahandbook
##############

class Company < ActiveRecord::Base
	set_table_name "data_mediahandbook_companies"
	belongs_to :sub_market, :class_name => "Branch"
	belongs_to :main_branch, :class_name => "Branch"
	has_and_belongs_to_many :sub_branches, :class_name => "Branch", :limit => 6, :join_table => "mediahandbook_branches_companies"
	has_many :people
	#TODO maybe we need a validation for creating 6 sub_branches max
end

class Branch < ActiveRecord::Base
	set_table_name "data_mediahandbook_branches"
	has_and_belongs_to_many :companies, :join_table => "mediahandbook_branches_companies"
end

class Person < ActiveRecord::Base
	set_table_name "mediahandbook_people"
	belongs_to :company
end

#########
#Calendar
#########

class Event < ActiveRecord::Base
	belongs_to :category, :class_name => "Branch"
	belongs_to :host
	has_one :venue
end

class Venue < ActiveRecord::Base
	belongs_to :event
end

class Host < ActiveRecord::Base
	has_many :events
end

