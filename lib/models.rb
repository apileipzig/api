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
  belongs_to :mkw_branch, :class_name => "Branch", :conditions => "internal_type = 'mkw_branch'"
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

  validates_numericality_of :mkw_branch_id, :allow_nil => true
  validate :existence_of_mkw_branch_id
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
  
  def existence_of_mkw_branch_id
    errors.add(:mkw_branch_id, "does not exist.") unless Branch.exists?(:id => mkw_branch_id, :internal_type => 'mkw_branch') unless mkw_branch_id.nil?
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
  validates_format_of :phone, :mobile, :fax, :with => /^(\+[0-9]+ |0)[1-9]{2,} [0-9]{2,}(\-[0-9]+|)$/, :allow_nil => true
  validates_format_of :url, :with => /^(http|https)\:\/\/[a-zA-Z0-9\-\.]+[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :allow_nil => true
  validates_length_of :company, :street, :housenumber_additional, :city, :maximum => 255
  validates_format_of :street, :without => /(str|str.)$/i, :message => "is invalid. Please use 'straße' and not 'str' or 'str.'.", :allow_nil => true
  validates_numericality_of :housenumber, :allow_nil => true
  validates_length_of :postcode, :maximum => 5
  validates_format_of :postcode, :with => /^[0-9]{5}$/, :allow_nil => true
  validates_format_of :email, :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, :allow_nil => true
end

##########
#Districts
##########

class District < ActiveRecord::Base
  set_table_name "data_district_districts"
  validates_presence_of :number, :name
  validates_numericality_of :number, :only_integer => true
  validates_length_of :name, :maximum => 255
  validates_uniqueness_of :number, :name
end


class Street < ActiveRecord::Base
  set_table_name "data_district_streets"
  belongs_to :district, :class_name => "District"
  validates_presence_of :district_id
  validates_numericality_of :district_id

  validates_presence_of :name, :housenumber, :postcode
  validates_length_of :name, :housenumber_additional, :maximum => 255
  validates_numericality_of :housenumber, :postcode, :only_integer => true
  validates_length_of :postcode, :maximum => 5
end

class Statistic < ActiveRecord::Base
  set_table_name "data_district_statistics"
  belongs_to :district, :class_name => "District"
  validates_presence_of :district_id
  validates_numericality_of :district_id
 
  validates_numericality_of :area 
  validates_numericality_of :inhabitants_total, :male_total, :male_0_4, :male_5_9, :male_10_14, :male_15_19, :male_20_24, :male_25_29, :male_30_34, :male_35_39, :male_40_44, :male_45_49, :male_50_54, :male_55_59, :male_60_64, :male_65_69, :male_70_74, :male_75_79, :male_80, :female_total, :female_0_4, :female_5_9, :female_10_14, :female_15_19, :female_20_24, :female_25_29, :female_30_34, :female_35_39, :female_40_44, :female_45_49, :female_50_54, :female_55_59, :female_60_64, :female_65_69, :female_70_74, :female_75_79, :female_80, :family_status_single, :family_status_married, :family_status_widowed, :family_status_divorced, :family_status_unknown, :religion_protestant, :religion_catholic, :religion_other_or_none, :citizenship_germany, :citizenship_albania, :citizenship_bosnia_and_herzegovina, :citizenship_belgium, :citizenship_bulgaria, :citizenship_denmark, :citizenship_estonia, :citizenship_finland, :citizenship_france, :citizenship_croatia, :citizenship_slovenia, :citizenship_serbia_and_montenegro, :citizenship_serbia_and_kosovo, :citizenship_greece, :citizenship_ireland, :citizenship_iceland, :citizenship_italy, :citizenship_latvia, :citizenship_montenegro, :citizenship_lithuania, :citizenship_luxembourg, :citizenship_macedonia, :citizenship_malta, :citizenship_moldova, :citizenship_netherlands, :citizenship_norway, :citizenship_kosovo, :citizenship_austria, :citizenship_poland, :citizenship_portugal, :citizenship_romania, :citizenship_slovakia, :citizenship_sweden, :citizenship_switzerland, :citizenship_russian_federation, :citizenship_spain, :citizenship_czechoslovakia, :citizenship_turkey, :citizenship_czech_republic, :citizenship_hungary, :citizenship_ukraine, :citizenship_united_kingdom, :citizenship_belarus, :citizenship_serbia, :citizenship_cyprus, :citizenship_algeria, :citizenship_angola, :citizenship_eritrea, :citizenship_ethopia, :citizenship_botswana, :citizenship_benin, :citizenship_cote_d_ivoire, :citizenship_nigeria, :citizenship_zimbabwe, :citizenship_gambia, :citizenship_ghana, :citizenship_mauritania, :citizenship_cap_verde, :citizenship_kenya, :citizenship_republic_of_congo, :citizenship_democratic_republic_of_congo, :citizenship_liberia, :citizenship_libya, :citizenship_madagascar, :citizenship_mali, :citizenship_morocco, :citizenship_mauritius, :citizenship_mozambique, :citizenship_niger, :citizenship_malawi, :citizenship_zambia, :citizenship_burkina_faso, :citizenship_guinea_bissau, :citizenship_guinea, :citizenship_cameroon, :citizenship_south_africa, :citizenship_rwanda, :citizenship_namibia, :citizenship_senegal, :citizenship_seychelles, :citizenship_sierra_leone, :citizenship_somalia, :citizenship_equatorial_guinea, :citizenship_sudan, :citizenship_tanzania, :citizenship_togo, :citizenship_tunisia, :citizenship_uganda, :citizenship_egypt, :citizenship_unknown, :citizenship_antigua_and_barbuda, :citizenship_argentinia, :citizenship_bahamas, :citizenship_bolvia, :citizenship_brazil, :citizenship_chile, :citizenship_costa_rica, :citizenship_dominican_republic, :citizenship_ecuador, :citizenship_el_salvador, :citizenship_guatemala, :citizenship_haiti, :citizenship_honduras, :citizenship_canada, :citizenship_colombia, :citizenship_cuba, :citizenship_mexico, :citizenship_nicaragua, :citizenship_jamaica, :citizenship_panama, :citizenship_peru, :citizenship_uruguay, :citizenship_venezuela, :citizenship_united_states, :citizenship_trinidad_and_tobago, :citizenship_unknown2, :citizenship_yemen, :citizenship_armenia, :citizenship_afghanistan, :citizenship_bahrain, :citizenship_azerbaijan, :citizenship_bhutan, :citizenship_myanmar, :citizenship_georgia, :citizenship_sri_lanka, :citizenship_vietnam, :citizenship_north_korea, :citizenship_india, :citizenship_indonesia, :citizenship_iraq, :citizenship_iran, :citizenship_israel, :citizenship_japan, :citizenship_kazakhstan, :citizenship_jordan, :citizenship_cambodia, :citizenship_kuwait, :citizenship_laos, :citizenship_kyrgyzstan, :citizenship_lebanon, :citizenship_maldives, :citizenship_oman, :citizenship_mongolia, :citizenship_nepal, :citizenship_bangladesh, :citizenship_pakistan, :citizenship_phillipines, :citizenship_taiwan, :citizenship_south_korea, :citizenship_tadzhikistan, :citizenship_turkmenistan, :citizenship_saudia_arabia, :citizenship_singapore, :citizenship_syria, :citizenship_thailand, :citizenship_uzbekistan, :citizenship_china, :citizenship_malaysia, :citizenship_remainig_asia, :citizenship_australia, :citizenship_solomon_islands, :citizenship_new_zealand, :citizenship_samoa, :citizenship_inapplicable, :citizenship_unknown3, :citizenship_not_specified, :allow_nil => true, :only_integer => true

end

class Ihkcompany < ActiveRecord::Base
  set_table_name "data_district_ihkcompanies"
  belongs_to :district, :class_name => "District"
  validates_presence_of :district_id
  validates_numericality_of :district_id
  validates_numericality_of :companies_total, :agriculture_forestry_fishery, :mining, :processing_trade, :power_supply, :water_supply_and_waste_management, :building_contruction, :vehicle_maintenance, :traffic_and_warehousing, :hotel_and_restaurant_industry, :information_and_communication, :financial_and_insurance_services, :housing, :scientific_and_technical_services, :other_economic_services, :public_administration, :education, :health_care, :artistry_and_entertainment, :other_services, :private_services, :extraterritorial_organisations, :other, :allow_nil => true, :only_integer => true
end
