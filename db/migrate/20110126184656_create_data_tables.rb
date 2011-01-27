class CreateDataTables < ActiveRecord::Migration
  def self.up
    create_table :data_companies do |t|
			t.references	:branch
      t.string			:name										# Name der Firma
			t.string			:street									# offizieller Straßenname, "-Straße" ausschreiben!
			t.integer			:housenumber						# nur EINE Zahl, für alles weitere das Feld hausnummer_zusatz verwenden
			t.string			:housenumber_additional	# Zusatz zur Hausnummer: z.B. -45, a, Tor B, Gebäude 5, Aufgang G
			t.string			:postcode								# fünfstellige Postleitzahl (String, keine Zahl siehe http://de.wikipedia.org/wiki/Postleitzahl#Postleitzahlen_in_der_Datenverarbeitung)
			t.string 			:city										# offizieller Name des Ortes, Halle (Saale) -> korrekt, Halle an der Saale -> falsch
			t.string			:phone_primary					# eine primäre Rufummer nach DIN 5008 (http://de.wikipedia.org/wiki/Rufnummer#Schreibweisen)
			t.string			:phone_secondary				# sekundäre Rufnummer siehe phone_primary
			t.string			:fax_primary						# siehe phone_primary
			t.string			:fax_secondary					# siehe phone_primary
			t.string			:mobile_primary					# siehe phone_primary
			t.string			:mobile_secondary				# siehe phone_primary
			t.string			:email_primary					# eine primäre Emailadresse
			t.string			:email_secondary
			t.string			:url_primary						# eine primäre Url beginnend mit http://
			t.string			:url_secondary
			t.text				:description						# Beschreibung der Unternehmenstätigkeit
      t.timestamps
    end
		
		create_table :persons do |t| # kein data_ prefix weil personen nur über das unternehmen gefunden werden sollen/können
			t.references	:company
			t.string			:first_name
			t.string			:last_name
			t.string			:title
			t.string			:position		# position im unternehmen
			t.string			:type				# ansprechpartner oder geschäftsführer
			t.timestamps
		end

		create_table :data_branches do |t|
			t.integer			:parent_id
			t.integer			:cluster_id		#Clustereinteilung der Stadt Leipzig, Medienhandbuch ist imemr cluster_id = 1
			t.string			:internal_key	#interner Schlüssel der Stadt Leipzig z.b. A1 oder F5
			t.string			:name
			t.string			:description
			t.timestamps
		end	
  end

  def self.down
    drop_table	:data_companies
		drop_table	:persons
		drop_table	:data_branches
  end
end
