config = YAML.load_file('database.yml')

namespace :permissions do
  desc "Looks up all columns from tables beginning with data_ and creates CRUD Permissions for them"
  task :init do
    only_readable_list = ['id', 'created_at', 'updated_at']
		ActiveRecord::Base.establish_connection(config)
		require 'lib/models'
    ActiveRecord::Base.connection.tables.select{|t| t =~ /^data_/}.each do |table|
			source_name = table.split('_').second
      table_name = table.split('_').third
      puts "Creating permissions for table #{table_name}"
			permissions_to_generate = ActiveRecord::Base.connection.columns(table).map!{|column| column.name}
			
			table_name.singularize.capitalize.constantize.reflect_on_all_associations.map do |assoc|
				if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
					permissions_to_generate << assoc.name.to_s
				end
			end
						
			permissions_to_generate.each do |column_name|
        unless only_readable_list.include?(column_name)
          accesses =  %w[create read update delete count]
        else
          accesses = %w[read]
        end
        accesses.each do |access|
          #a little bit ugly how this works with 'delete' :)
          column_name = nil if access == 'delete' or access == 'count'
          if Permission.find_by_access_and_source_and_table_and_column(access, source_name, table_name, column_name).blank?
            unless access == 'delete' or access == 'count'
              Permission.create(:access => access, :source => source_name, :table => table_name, :column => column_name)
            else
              Permission.create(:access => access, :source => source_name, :table => table_name, :column => nil)
            end
            puts "Permission #{access} for column #{column_name} in table #{source_name}_#{table_name} created"
	        else
            puts "Permission #{access} for column #{column_name} in table #{source_name}_#{table_name} already exists."	      
	        end    
        end
      end
    end
  end
  
  desc "Renames Permissions for a given table and column preserving the rights given to users"
  task :rename, [:table, :old_name, :new_name] do |t, args|
		ActiveRecord::Base.establish_connection(config)
		require 'lib/models'
    unless args.table.blank? || args.old_name.blank? || args.new_name.blank?
      if ActiveRecord::Base.connection.tables.select{|t| t =~ /^data_/}.include?(args.table)
        old_permissions = Permission.find_all_by_source_and_table_and_column(args.table.split('_')[1], args.table.split('_')[2], args.old_name)
		    unless old_permissions.blank?
		      old_permissions.each do |permission|
		        permission.column = args.new_name
		        permission.save
		        puts "Renamed #{permission.access} Permission #{args.table} => #{args.old_name} to #{args.table} => #{args.new_name}"
		      end
		    else
		      puts "No Permissions with name #{args.old_name} for table #{args.table} found. Try running permissions:init first."
		    end        
      else
        puts "Table #{args.table} does not exist!"
      end
    else
      puts 'This script needs three parameters: table name, old column name, and new column name.'
      puts 'Example: rake "permissions:rename[data_company, address, place]" <= Attention! Mind the quotes!' 
    end
  end

  desc "Deletes Permissions for a given table and column."
  task :delete, [:table, :column] do |t, args|
		ActiveRecord::Base.establish_connection(config)
		require 'lib/models'
    unless args.table.blank? || args.column.blank?
      if ActiveRecord::Base.connection.tables.select{|t| t =~ /^data_/}.include?(args.table)
        permissions = Permission.find_all_by_table_and_column(args.table.split('_')[1], args.column)
		unless permissions.blank?
		  puts "Really delete the Permissions for column #{args.column} in table #{args.table}? Type \"Yes\" to confirm."
		  confirm = STDIN.gets
		  if confirm.downcase =~ /^yes/
		    permissions.each do |permission|
		      puts "Deleted #{permission.access} Permission with name #{args.column} for table #{args.table}"
		      permission.users.clear
		      permission.delete
		    end
		  else
		    puts 'Aborting. Nothing deleted.'
		  end
		else
		  puts "No Permissions with name #{args.column} for table #{args.table} found. Try running permissions:init first."
		end        
      else
        puts "Table #{args.table} does not exist!"
      end
    else
      puts 'This script needs two parameters: table name and column name.'
      puts 'Example: rake "permissions:delete[data_company, address]" <= Attention! Mind the quotes!' 
    end
  end
end
