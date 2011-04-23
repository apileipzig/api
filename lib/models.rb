# encoding: utf-8

ActiveRecord::Base.include_root_in_json = false # removes table names in json

class User < ActiveRecord::Base
  acts_as_authentic
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
  belongs_to :sub_market, :class_name => "Branch", :conditions => "internal_type = 'sub_market'"
  belongs_to :main_branch, :class_name => "Branch", :conditions => "internal_type = 'main_branch'"
  has_and_belongs_to_many :sub_branches, :class_name => "Branch", :limit => 6, :join_table => "mediahandbook_branches_companies", :conditions => "internal_type = 'sub_branch'"
  has_many :people
  #TODO maybe we need a validation for creating 6 sub_branches max
  #TODO validate capitalizing of city, street, ...
  #TODO: strip html tags and such stuff from text

  validates_presence_of :sub_market_id
  validates_numericality_of :sub_market_id, :allow_nil => true
  validate :existence_of_sub_market_id, :allow_nil => true
  
  validates_numericality_of :main_branch_id, :allow_nil => true
  validate :existence_of_main_branch_id
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :street, :housenumber_additional, :city, :maximum => 255
  validates_format_of :street, :without => /(str|str.)$/i, :message => "is invalid. Please use 'straße' and not 'str' or 'str.'.", :allow_nil => true
  validates_numericality_of :housenumber, :allow_nil => true
  validates_length_of :postcode, :maximum => 5
  validates_format_of :postcode, :with => /^[0-9]{5}$/, :allow_nil => true
  validates_format_of :phone_primary, :phone_secondary, :fax_primary, :fax_secondary, :mobile_primary, :mobile_secondary, :with => /^(\+[0-9]+ |0)[1-9]{2,} [0-9]{2,}(\-[0-9]+|)$/, :allow_nil => true
  validates_format_of :email_primary, :email_secondary, :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, :allow_nil => true
  validates_format_of :url_primary, :url_secondary, :with => /^(http|https)\:\/\/[a-zA-Z0-9\-\.]+[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :allow_nil => true
  
  def existence_of_main_branch_id
    errors.add(:main_branch_id, "does not exist.") unless Branch.exists?(:id => main_branch_id, :internal_type => 'main_branch') unless main_branch_id.nil?
  end
  
  def existence_of_sub_market_id
    #only check if sub_market is an integer > 0
    errors.add(:sub_market_id, "does not exist.") unless Branch.exists?(:id => sub_market_id, :internal_type => 'sub_market') unless sub_market_id.to_i == 0
  end
end

class Branch < ActiveRecord::Base
  set_table_name "data_mediahandbook_branches"
  has_and_belongs_to_many :companies, :join_table => "mediahandbook_branches_companies"
end

class Person < ActiveRecord::Base
  set_table_name "data_mediahandbook_people"
  belongs_to :company

  validates_presence_of :company_id, :first_name, :last_name, :occupation
  validates_length_of :first_name, :last_name, :type, :maximum => 255
  validate :type_of_occupation
  validates_numericality_of :company_id, :allow_nil => true
  validate :existence_of_company_id, :allow_nil => true

  def existence_of_company_id
    errors.add(:company_id, "does not exist.") unless Company.exists?(:id => company_id) unless company_id.nil?
  end

  def type_of_occupation
    errors.add(:occupation, "must be manager or contact.") unless occupation == 'manager' or occupation == 'contact'
  end
end

#########
#Calendar
#########

class Event < ActiveRecord::Base
  set_table_name "data_calendar_events"
  belongs_to :category, :class_name => "Branch", :conditions => "internal_type = 'sub_market'"
  belongs_to :host
  belongs_to :venue

  validates_presence_of :category_id
  validates_numericality_of :category_id, :allow_nil => true
  validate :existence_of_category_id, :allow_nil => true

  validates_presence_of :host_id
  validates_numericality_of :host_id, :allow_nil => true
  validate :existence_of_host_id, :allow_nil => true

  validates_presence_of :venue_id
  validates_numericality_of :venue_id, :allow_nil => true
  validate :existence_of_venue_id, :allow_nil => true

  validates_presence_of :user_id
  validates_numericality_of :user_id, :allow_nil => true
  validate :existence_of_user_id, :allow_nil => true
  
  validates_presence_of :name, :description, :date_from
  validates_length_of :name, :maximum => 255
  validates_format_of :date_from, :with => /^(1|2)[0-9]{3}\-(0|1)[0-9]{1}\-[0-3]{1}[0-9]{1}$/
  validates_format_of :date_to, :with => /^(1|2)[0-9]{3}\-(0|1)[0-9]{1}\-[0-3]{1}[0-9]{1}$/, :allow_nil => true
  validate :format_of_time_from, :allow_nil => true
  validate :format_of_time_to, :allow_nil => true
  #TODO: strip html tags and such stuff from description
  validates_format_of :url, :with => /^(http|https)\:\/\/[a-zA-Z0-9\-\.]+[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :allow_nil => true
  
  def format_of_time_from
    errors.add(:time_from, "is invalid.") unless time_from_before_type_cast =~ /^[0-2]{1}[0-9]{1}\:[0-5]{1}[0-9]{1}\:[0-5]{1}[0-9]{1}$/ unless time_from_before_type_cast.nil?
  end

  def format_of_time_to
    errors.add(:time_to, "is invalid.") unless time_to_before_type_cast =~ /^[0-2]{1}[0-9]{1}\:[0-5]{1}[0-9]{1}\:[0-5]{1}[0-9]{1}$/ unless time_to_before_type_cast.nil?
  end

  def existence_of_category_id
    errors.add(:category_id, "does not exist.") unless Branch.exists?(:id => category_id, :internal_type => 'sub_market') unless category_id.to_i == 0
  end

  def existence_of_host_id
    errors.add(:host_id, "does not exist.") unless Host.exists?(:id => host_id) unless host_id.to_i == 0
  end

  def existence_of_venue_id
    errors.add(:venue_id, "does not exist.") unless Venue.exists?(:id => venue_id) unless venue_id.to_i == 0
  end

  def existence_of_user_id
    errors.add(:user_id, "does not exist.") unless User.exists?(:id => user_id) unless user_id.to_i == 0
  end
end

class Venue < ActiveRecord::Base
  set_table_name "data_calendar_venues"
  has_many :events

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :street, :housenumber_additional, :city, :maximum => 255
  validates_format_of :street, :without => /(str|str.)$/i, :message => "is invalid. Please use 'straße' and not 'str' or 'str.'.", :allow_nil => true
  validates_numericality_of :housenumber, :allow_nil => true
  validates_length_of :postcode, :maximum => 5
  validates_format_of :postcode, :with => /^[0-9]{5}$/, :allow_nil => true
  validates_format_of :phone, :with => /^(\+[0-9]+ |0)[1-9]{2,} [0-9]{2,}(\-[0-9]+|)$/, :allow_nil => true
  #TODO: strip html tags and such stuff from description
  validates_format_of :url, :with => /^(http|https)\:\/\/[a-zA-Z0-9\-\.]+[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :allow_nil => true
end

class Host < ActiveRecord::Base
  set_table_name "data_calendar_hosts"
  has_many :events
  validates_presence_of :first_name, :last_name
  validates_length_of :first_name, :last_name, :maximum => 255
  validates_format_of :phone, :mobile, :with => /^(\+[0-9]+ |0)[1-9]{2,} [0-9]{2,}(\-[0-9]+|)$/, :allow_nil => true
  validates_format_of :url, :with => /^(http|https)\:\/\/[a-zA-Z0-9\-\.]+[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :allow_nil => true
end

