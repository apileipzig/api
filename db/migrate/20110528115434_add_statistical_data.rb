class AddStatisticalData < ActiveRecord::Migration
  def self.up
    create_table :data_district_districts do |t|
      t.integer  :number
      t.string   :name
      t.timestamps
    end

    create_table :data_district_streets do |t|
      t.integer  :district_id
      t.string   :internal_key
      t.string   :name
      t.integer  :housenumber
      t.string   :housenumber_additional
      t.string   :postcode
      t.timestamps
    end

    create_table :data_district_statistics do |t|
      t.integer  :district_id
      t.float    :area
      t.integer  :inhabitants_total
      t.integer  :male_total
      t.integer  :male_0_4
      t.integer  :male_5_9
      t.integer  :male_10_14
      t.integer  :male_15_19
      t.integer  :male_20_24
      t.integer  :male_25_29
      t.integer  :male_30_34
      t.integer  :male_35_39
      t.integer  :male_40_44
      t.integer  :male_45_49
      t.integer  :male_50_54
      t.integer  :male_55_59
      t.integer  :male_60_64
      t.integer  :male_65_69
      t.integer  :male_70_74
      t.integer  :male_75_79
      t.integer  :male_80
      t.integer  :female_total
      t.integer  :female_0_4
      t.integer  :female_5_9
      t.integer  :female_10_14
      t.integer  :female_15_19
      t.integer  :female_20_24
      t.integer  :female_25_29
      t.integer  :female_30_34
      t.integer  :female_35_39
      t.integer  :female_40_44
      t.integer  :female_45_49
      t.integer  :female_50_54
      t.integer  :female_55_59
      t.integer  :female_60_64
      t.integer  :female_65_69
      t.integer  :female_70_74
      t.integer  :female_75_79
      t.integer  :female_80
      t.integer  :family_status_single
      t.integer  :family_status_married
      t.integer  :family_status_widowed
      t.integer  :family_status_divorced
      t.integer  :family_status_unknown
      t.integer  :citizenship_germany
      t.integer  :citizenship_albania
      t.integer  :citizenship_bosnia_and_herzegovina
      t.integer  :citizenship_belgium
      t.integer  :citizenship_bulgaria
      t.integer  :citizenship_denmark
      t.integer  :citizenship_estonia
      t.integer  :citizenship_finland
      t.integer  :citizenship_france
      t.integer  :citizenship_croatia
      t.integer  :citizenship_slovenia
      t.integer  :citizenship_serbia_and_montenegro
      t.integer  :citizenship_serbia_and_kosovo
      t.integer  :citizenship_greece
      t.integer  :citizenship_ireland
      t.integer  :citizenship_iceland
      t.integer  :citizenship_italy
      t.integer  :citizenship_latvia
      t.integer  :citizenship_montenegro
      t.integer  :citizenship_lithuania
      t.integer  :citizenship_luxembourg
      t.integer  :citizenship_macedonia
      t.integer  :citizenship_malta
      t.integer  :citizenship_moldova
      t.integer  :citizenship_netherlands
      t.integer  :citizenship_norway
      t.integer  :citizenship_kosovo
      t.integer  :citizenship_austria
      t.integer  :citizenship_poland
      t.integer  :citizenship_portugal
      t.integer  :citizenship_romania
      t.integer  :citizenship_slovakia
      t.integer  :citizenship_sweden
      t.integer  :citizenship_switzerland
      t.integer  :citizenship_russian_federation
      t.integer  :citizenship_spain
      t.integer  :citizenship_czechoslovakia
      t.integer  :citizenship_turkey
      t.integer  :citizenship_czech_republic
      t.integer  :citizenship_hungary
      t.integer  :citizenship_ukraine
      t.integer  :citizenship_united_kingdom
      t.integer  :citizenship_belarus
      t.integer  :citizenship_serbia
      t.integer  :citizenship_cyprus
      t.integer  :citizenship_algeria
      t.integer  :citizenship_angola
      t.integer  :citizenship_eritrea
      t.integer  :citizenship_ethopia
      t.integer  :citizenship_botswana
      t.integer  :citizenship_benin
      t.integer  :citizenship_cote_d_ivoire
      t.integer  :citizenship_nigeria
      t.integer  :citizenship_zimbabwe
      t.integer  :citizenship_gambia
      t.integer  :citizenship_ghana
      t.integer  :citizenship_mauritania
      t.integer  :citizenship_cap_verde
      t.integer  :citizenship_kenya
      t.integer  :citizenship_republic_of_congo
      t.integer  :citizenship_democratic_republic_of_congo
      t.integer  :citizenship_liberia
      t.integer  :citizenship_libya
      t.integer  :citizenship_madagascar
      t.integer  :citizenship_mali
      t.integer  :citizenship_morocco
      t.integer  :citizenship_mauritius
      t.integer  :citizenship_mozambique
      t.integer  :citizenship_niger
      t.integer  :citizenship_malawi
      t.integer  :citizenship_zambia
      t.integer  :citizenship_burkina_faso
      t.integer  :citizenship_guinea_bissau
      t.integer  :citizenship_guinea
      t.integer  :citizenship_cameroon
      t.integer  :citizenship_south_africa
      t.integer  :citizenship_rwanda
      t.integer  :citizenship_namibia
      t.integer  :citizenship_senegal
      t.integer  :citizenship_seychelles
      t.integer  :citizenship_sierra_leone
      t.integer  :citizenship_somalia
      t.integer  :citizenship_equatorial_guinea
      t.integer  :citizenship_sudan
      t.integer  :citizenship_tanzania
      t.integer  :citizenship_togo
      t.integer  :citizenship_tunisia
      t.integer  :citizenship_uganda
      t.integer  :citizenship_egypt
      t.integer  :citizenship_unknown
      t.integer  :citizenship_antigua_and_barbuda
      t.integer  :citizenship_argentinia
      t.integer  :citizenship_bahamas
      t.integer  :citizenship_bolvia
      t.integer  :citizenship_brazil
      t.integer  :citizenship_chile
      t.integer  :citizenship_costa_rica
      t.integer  :citizenship_dominican_republic
      t.integer  :citizenship_ecuador
      t.integer  :citizenship_el_salvador
      t.integer  :citizenship_guatemala
      t.integer  :citizenship_haiti
      t.integer  :citizenship_honduras
      t.integer  :citizenship_canada
      t.integer  :citizenship_colombia
      t.integer  :citizenship_cuba
      t.integer  :citizenship_mexico
      t.integer  :citizenship_nicaragua
      t.integer  :citizenship_jamaica
      t.integer  :citizenship_panama
      t.integer  :citizenship_peru
      t.integer  :citizenship_uruguay
      t.integer  :citizenship_venezuela
      t.integer  :citizenship_united_states
      t.integer  :citizenship_trinidad_and_tobago
      t.integer  :citizenship_unknown2
      t.integer  :citizenship_yemen
      t.integer  :citizenship_armenia
      t.integer  :citizenship_afghanistan
      t.integer  :citizenship_bahrain
      t.integer  :citizenship_azerbaijan
      t.integer  :citizenship_bhutan
      t.integer  :citizenship_myanmar
      t.integer  :citizenship_georgia
      t.integer  :citizenship_sri_lanka
      t.integer  :citizenship_vietnam
      t.integer  :citizenship_north_korea
      t.integer  :citizenship_india
      t.integer  :citizenship_indonesia
      t.integer  :citizenship_iraq
      t.integer  :citizenship_iran
      t.integer  :citizenship_israel
      t.integer  :citizenship_japan
      t.integer  :citizenship_kazakhstan
      t.integer  :citizenship_jordan
      t.integer  :citizenship_cambodia
      t.integer  :citizenship_kuwait
      t.integer  :citizenship_laos
      t.integer  :citizenship_kyrgyzstan
      t.integer  :citizenship_lebanon
      t.integer  :citizenship_maldives
      t.integer  :citizenship_oman
      t.integer  :citizenship_mongolia
      t.integer  :citizenship_nepal
      t.integer  :citizenship_bangladesh
      t.integer  :citizenship_pakistan
      t.integer  :citizenship_phillipines
      t.integer  :citizenship_taiwan
      t.integer  :citizenship_south_korea
      t.integer  :citizenship_tadzhikistan
      t.integer  :citizenship_turkmenistan
      t.integer  :citizenship_saudia_arabia
      t.integer  :citizenship_singapore
      t.integer  :citizenship_syria
      t.integer  :citizenship_thailand
      t.integer  :citizenship_uzbekistan
      t.integer  :citizenship_china
      t.integer  :citizenship_malaysia
      t.integer  :citizenship_remainig_asia
      t.integer  :citizenship_australia
      t.integer  :citizenship_solomon_islands
      t.integer  :citizenship_new_zealand
      t.integer  :citizenship_samoa
      t.integer  :citizenship_inapplicable
      t.integer  :citizenship_unknown3
      t.integer  :citizenship_not_specified
      t.timestamps
    end

    create_table :data_district_companies do |t|
      t.integer  :district_id
      t.integer  :companies_total
      t.integer  :agriculture_forestry_fishery
      t.integer  :mining
      t.integer  :processing_trade
      t.integer  :power_supply
      t.integer  :water_supply_and_waste_management
      t.integer  :building_contruction
      t.integer  :vehicle_maintenance
      t.integer  :traffic_and_warehousing
      t.integer  :hotel_and_restaurant_industry
      t.integer  :information_and_communication
      t.integer  :financial_and_insurance_services
      t.integer  :housing
      t.integer  :scientific_and_technical_services
      t.integer  :other_economic_services
      t.integer  :public_administration
      t.integer  :education
      t.integer  :health_care
      t.integer  :artistry_and_entertainment
      t.integer  :other_services
      t.integer  :private_services
      t.integer  :extraterritorial_organisations
      t.integer  :other
      t.timestamps
    end
  end

  def self.down
    drop_table :data_district_streets
    drop_table :data_district_statistics
    drop_table :data_district_companies
    drop_table :data_district_districts
  end
end
