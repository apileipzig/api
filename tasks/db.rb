config = YAML.load_file('database.yml')

#code borrowed from here: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/railties/databases.rake

namespace :db do
	desc "create your database"
  task :create do
		if config['adapter'] =~ /sqlite/
    	if File.exist?(config['database'])
      	$stderr.puts "#{config['database']} already exists"
      else
        begin
          # Create the SQLite database
          ActiveRecord::Base.establish_connection(config)
          ActiveRecord::Base.connection
        rescue Exception => e
          $stderr.puts e, *(e.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
      end
    else
    	@charset   = ENV['CHARSET']   || 'utf8'
    	@collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    	creation_options = {:charset => (config['charset'] || @charset), :collation => (config['collation'] || @collation)}
			ActiveRecord::Base.establish_connection(config.merge('database' => nil))
			ActiveRecord::Base.connection.create_database(config['database'], creation_options)
    end
  end

  desc "migrate your database"
  task :migrate do
		ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Migrator.migrate(
      'db/migrate', 
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )

		require 'active_record/schema_dumper'
    File.open("db/schema.rb", "w") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc 'Drops the database'
  task :drop do
		begin
			if config['adapter'] =~ /sqlite/
    		FileUtils.rm(config['database'])
			else
				ActiveRecord::Base.establish_connection(config)
		    ActiveRecord::Base.connection.drop_database config['database']
			end
		rescue Exception => e
			$stderr.puts "Couldn't drop #{config['database']} : #{e.inspect}"
		end
  end

  desc 'Resets your database using your migrations for the current environment (drop -> create -> migrate)'
  task :reset => ["db:drop", "db:create", "db:migrate"]

  desc 'Runs the "up" for a given migration VERSION.'
  task :up do
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    raise "VERSION is required" unless version
		ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Migrator.run(:up, "db/migrate/", version)

		require 'active_record/schema_dumper'
    File.open("db/schema.rb", "w") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc 'Runs the "down" for a given migration VERSION.'
  task :down do
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    raise "VERSION is required" unless version
		ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Migrator.run(:down, "db/migrate/", version)

		require 'active_record/schema_dumper'
    File.open("db/schema.rb", "w") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc 'Load the seed data (Specify file with "file=" if no file is specified it will seed from db/seeds.rb)'
  task :seed do
		seed_file = ENV["file"] ? ENV["file"].to_s : File.join('db', 'seeds.rb')
    if File.exist?(seed_file)
			ActiveRecord::Base.establish_connection(config)
			require 'lib/models'
			begin
			require seed_file
			rescue Exception => e
				$stderr.puts e
			end
		else
			puts "No file found!"
		end
  end

  desc "create an ActiveRecord migration in ./db/migrate"
  task :create_migration do
    name = ENV['NAME']
    abort("no NAME specified. use `rake db:create_migration NAME=create_users`") if !name

    migrations_dir = File.join("db", "migrate")
    version = ENV["VERSION"] || Time.now.strftime("%Y%m%d%H%M%S") 
    filename = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    FileUtils.mkdir_p(migrations_dir)

    open(File.join(migrations_dir, filename), 'w') do |f|
      f << (<<-EOS).gsub("      ", "")
class #{migration_name} < ActiveRecord::Migration
	def self.up
		create_table :#{name} do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :#{name}
	end
end

EOS
    end
  end
end

