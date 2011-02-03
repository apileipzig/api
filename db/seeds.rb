Branch.create(:name => "Cluster Medien")
Branch.create(:parent_id => 1, :cluster_id => 1, :internal_key => "1A", :name => "Interaktive Medien", :description => "Ganz tolle Interaktionen möglich.")
Branch.create(:parent_id => 1, :cluster_id => 1, :internal_key => "1B", :name => "Druck")
Branch.create(:parent_id => 1, :cluster_id => 1, :internal_key => "1C", :name => "Film", :description => "Viele gute Filme.")
Branch.create(:parent_id => 3, :cluster_id => 1, :internal_key => "1C1", :name => "Dokumentarfilm", :description => "Viele gute Dok-Filme.")
Company.create(:main_branch => Branch.find(1), :name => "hybrid art lab", :street => "Karl-Heine-Straße", :housenumber => 93, :housenumber_additional => "Tor B", :postcode => "04229", :city => "Leipzig", :phone_primary => "+49 341 12345-67", :mobile_primary => "+49 176 12345678", :email_primary => "hello@hybridartlab.com", :url_primary => "http://www.hybridartlab.com", :description => "Labor für interaktive Konzepte, tech-basierte Ideen und Prototypen.")
Company.create(:main_branch => Branch.find(2), :name => "druck schmidt+partner", :street => "Industriestraße", :housenumber => 5, :housenumber_additional => "a", :postcode => "04229", :city => "Leipzig", :phone_primary => "+49 341 98765-43", :mobile_primary => "+49 176 87654321", :email_primary => "mail@druckschmidtpartner.de", :url_primary => "http://www.druckschmidtpartner.de", :description => "Eine tolle Druckerei.")
Company.create(:main_branch => Branch.find(3), :name => "Filmproduktion Müller", :street => "Wilhelm-Leuschner-Platz", :housenumber => 12, :postcode => "04105", :city => "Leipzig", :phone_primary => "+49 341 11111-43", :phone_secondary => "+49 341 22222-44", :fax_primary => "+49 341 33333-43", :mobile_primary => "+49 176 88888888", :email_primary => "info@film-mueller.de", :url_primary => "http://www.film-mueller.de", :description => "Eine tolle Filmproduktionsfirma.")
Company.create(:main_branch => Branch.find(3), :name => "ABC Movie&Print Media Group", :street => "Könneritzstraße", :housenumber => 104, :postcode => "04123", :city => "Leipzig", :phone_primary => "+49 341 454545-43", :phone_secondary => "+49 341 454545-44", :fax_primary => "+49 341 76567-43", :mobile_primary => "+49 176 876678", :email_primary => "info@abcmediagroup.de", :url_primary => "http://www.abcmediagroup.de", :description => "ABC Movie&Print Produktionen der Spitzenklasse.")
Person.create(:company_id => 1, :first_name => "Hal", :last_name => "Bot", :title => "Prof. Dr. oec.", :position => "CEO", :type => 0)
Person.create(:company_id => 2, :first_name => "Frank", :last_name => "Schmidt", :position => "Inhaber", :type => 0)
Person.create(:company_id => 2, :first_name => "Peter", :last_name => "Partner", :position => "Inhaber", :type => 0)
Person.create(:company_id => 2, :first_name => "Sabine", :last_name => "Schmidt", :position => "Vertrieb", :type => 1)
Person.create(:company_id => 3, :first_name => "Jimmy", :last_name => "Müller", :position => "Inhaber", :type => 0)
Person.create(:company_id => 4, :first_name => "Alfons", :last_name => "Becker", :position => "Inhaber", :type => 0)

