class User < ActiveRecord::Base
	has_and_belongs_to_many :permissions
end
class Permission < ActiveRecord::Base
	has_and_belongs_to_many :users
end
class Datatable < ActiveRecord::Base # no real Table, just used for Data-Tables
end
