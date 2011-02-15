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
	#TODO validate capitalizing of city, street, ...
	
	#validate sub_market
	#validate main_branch_id
	validates_presence_of :name
	validates_uniqueness_of :name
  validates_length_of :name, :street, :housenumber_additional, :city, :maximum => 255
	#validate if street is written with "straße" and not "str" or "str."
	validates_numericality_of :housenumber, :allow_nil => true
	validates_length_of :postcode, :maximum => 5
	validates_format_of :postcode, :with => /^[0-9]{5}$/, :allow_nil => true
	validates_format_of :phone_primary, :phone_secondary, :fax_primary, :fax_secondary, :mobile_primary, :mobile_secondary, :with => /^(\+[0-9]+ |0)[1-9]{2,} [0-9]{2,}(\-[0-9]+|)$/, :allow_nil => true
	validates_format_of :email_primary, :email_secondary, :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, :allow_nil => true
	validates_format_of :url_primary, :url_secondary, :with => URI::regexp(%w(http https)), :allow_nil => true
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
	belongs_to :venue
end

class Venue < ActiveRecord::Base
	has_many :events
end

class Host < ActiveRecord::Base
	has_many :events
end

