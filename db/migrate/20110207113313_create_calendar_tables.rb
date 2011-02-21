class CreateCalendarTables < ActiveRecord::Migration
	def self.up
		create_table :data_calendar_events do |t|
			t.references	:category			# Kategorie des Events (ist sub_market)
			t.references	:host
			t.references	:venue
			t.date				:date_from
			t.time				:time_from
			t.date				:date_to
			t.time				:time_to
			t.string			:name					# Name des Events
			t.text				:description	# Beschreibung des Events
			t.string			:url					# eine primäre Url beginnend mit http://
			t.timestamps
		end

		create_table :data_calendar_venues do |t|
			t.string			:name										# Name des Veranstaltungsortes
			t.string			:street									# offizieller Straßenname, "-Straße" ausschreiben!
			t.integer			:housenumber						# nur EINE Zahl, für alles weitere das Feld hausnummer_zusatz verwenden
			t.string			:housenumber_additional	# Zusatz zur Hausnummer: z.B. -45, a, Tor B, Gebäude 5, Aufgang G
			t.string			:postcode								# fünfstellige Postleitzahl (String, keine Zahl siehe http://de.wikipedia.org/wiki/Postleitzahl#Postleitzahlen_in_der_Datenverarbeitung)
			t.string			:city										# offizieller Name des Ortes, Halle (Saale) -> korrekt, Halle an der Saale -> falsch
			t.string			:phone									# eine primäre Rufummer nach DIN 5008 (http://de.wikipedia.org/wiki/Rufnummer#Schreibweisen)
			t.text				:description						# Beschreibung des Veranstaltungsortes
			t.string			:url										# eine primäre Url beginnend mit http://
			t.timestamps
		end

		create_table :data_calendar_hosts do |t|
			t.string			:first_name
			t.string			:last_name
			t.string			:phone					# eine primäre Rufummer nach DIN 5008 (http://de.wikipedia.org/wiki/Rufnummer#Schreibweisen)
			t.string			:mobile					# siehe phone
			t.string			:url						# eine primäre Url beginnend mit http://
			t.timestamps
		end
	end

	def self.down
		drop_table	:data_calendar_events
		drop_table	:data_calendar_venues
		drop_table	:data_calendar_hosts
	end
end

