require 'rubygems'
require 'bundler'
Bundler.require()

require 'lib/config'

#TODO:
##validate which columns can be changed / are needed
#handle parametrized requests (do this in a generic way, which means allow every parameter which is a table column of the model too)
#validate callbacks

	set :root, APP_ROOT

	get '/' do
		throw_error 400, :message => "Wrong url format."
	end

	get '/:source/?' do
		#TODO: throw other error her, maybe a help message
		throw_error 400
	end

	#request a list in rest/rails style
	get '/:source/:model/?' do
		logger
		validate
		
    conditions = {:select => only_permitted_columns}
    #only set limit and offset explicit
    conditions[:limit] = params[:limit] unless params[:limit].nil?
    conditions[:offset] = params[:offset] unless params[:offset].nil?
    #only set pagination if limit is set
		output :data => params[:model].singularize.capitalize.constantize.all(conditions), :pagination => conditions[:limit] ? true : false
	end

  get '/:source/:model/search/?' do
		logger
		validate
		
    data = params[:model].singularize.capitalize.constantize
		# 1. search q in all permitted columns
		permitted_columns = only_permitted_columns
		conditions = [""]
		if !params[:q].nil? && params[:q].length > 0
			conditions[0] = "(" + permitted_columns.map{|k| "#{k} LIKE ?" }.join(" OR ") + ")"
			for i in 1..permitted_columns.length
				conditions[i] = "%#{params[:q]}%"
			end
		end
		
		# 2. search other paramters
		params.each do |k,v|
			if permitted_columns.include?(k) && v.to_s.length > 0
			  comparator = data.columns.map{|c| c if c.name == k and c.type == :integer}.compact[0].nil? ? "LIKE" : "="
				if(conditions[0].length > 0)
					conditions[0] << " AND #{k} #{comparator} ?"
				else
					conditions[0] << "#{k} #{comparator} ?"
				end
        if comparator == "="
				  conditions.push("#{v}")
        else
          conditions.push("%#{v}%")
        end
			end
		end
		
		# no output without parameters, otherwise it would return all datasets
		if conditions.size > 1
		  c = {:select => permitted_columns, :conditions=>conditions}
      count = data.all(c).length
		  c[:limit] = params[:limit] unless params[:limit].nil?
      c[:offset] = params[:offset] unless params[:offset].nil?
			output :data => data.all(c), :pagination => c[:limit] ? true : false, :count => count
		else
			output :error => "No search parameters."
		end
	end

  get '/:source/:model/count/?' do
		logger
		validate
    puts params[:model].singularize.capitalize.constantize.count
    output :count => params[:model].singularize.capitalize.constantize.count
  end

	#per model requests
	#create
	post '/:source/:model' do
		logger
		validate

		data = params[:model].singularize.capitalize.constantize.new(create_only_permitted_data)
		data.class.reflect_on_all_associations.map do |assoc|
			if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
				unless params[assoc.name].nil?
					assoc_array =[]
					assoc_array = params[assoc.name].split(",").map{ |n| n.to_i}
					#next two lines mean for example the following: Company.sub_branch_ids = [1,2,3]
					m = assoc.name.to_s.singularize + "_ids="
					data.send m.to_sym, assoc_array
				end
			end
		end

		if data.save
			output :success => {:message => "#{params[:model].singularize.capitalize} was saved with id = #{data.id}.", :id => data.id}
		else
			throw_error 404, :message => data.errors
		end
	end

	#read
	get '/:source/:model/:id' do
		logger
		validate
		
		begin
			output :model => params[:model].singularize.capitalize.constantize.find(params[:id], :select => only_permitted_columns)
		rescue Exception => e
			throw_error 404, :message => {:message => e.to_s, :id => params[:id].to_i}
		end
	end

	#update
	put '/:source/:model/:id' do
		logger
		validate
		
		begin
			data = params[:model].singularize.capitalize.constantize.find(params[:id])
			data.class.reflect_on_all_associations.map do |assoc|
				if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
					unless params[assoc.name].nil?
						assoc_array =[]
						assoc_array = params[assoc.name].split(",").map{ |n| n.to_i}
						#next two lines mean for example the following: Company.sub_branch_ids = [1,2,3]
						m = assoc.name.to_s.singularize + "_ids="
						data.send m.to_sym, assoc_array
					end
				end
			end

			if data.update_attributes(create_only_permitted_data)
				output :success => {:message => "#{params[:model].singularize.capitalize} with id = #{params[:id]} was updated.", :id => data.id}
			else
				throw_error 404, :message => data.errors
			end
		rescue Exception => e
			throw_error 404, :message => {:message => e.to_s, :id => params[:id].to_i}
		end
	end

	#delete
	delete '/:source/:model/:id' do
		logger
		validate
		
    begin
      data = params[:model].singularize.capitalize.constantize.find(params[:id])
		  data.destroy
			output :success => {:message => "Deleted #{params[:model].singularize.capitalize} with id = #{params[:id]}.", :id => params[:id].to_i}
    rescue Exception => e
			throw_error 404, :message => {:message => e.to_s, :id => params[:id].to_i}
		end
	end

	#methods to catch all other request
	post '/*' do
		throw_error 400, :message => "Wrong url format."
	end

	get '/*' do
		throw_error 400, :message => "Wrong url format."
	end

	put '/*' do
		throw_error 400, :message => "Wrong url format."
	end

	delete '/*' do
		throw_error 400, :message => "Wrong url format."
	end
