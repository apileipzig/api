require 'active_record'
config = YAML.load_file('database.yml')

namespace :db do
	desc "create your database"
  task :create do
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    creation_options = {:charset => (config['charset'] || @charset), :collation => (config['collation'] || @collation)}
		ActiveRecord::Base.establish_connection(config.merge('database' => nil))
		ActiveRecord::Base.connection.create_database(config['database'], creation_options)
  end

  desc "migrate your database"
  task :migrate do
		ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Migrator.migrate(
      'db/migrate', 
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end

  desc 'Drops the database'
  task :drop do
    begin
			ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection.drop_database config['database']
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
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
			ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Migrator.run(:down, "db/migrate/", version)
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
        end

        def self.down
        end
      end
      EOS
    end
  end
end

