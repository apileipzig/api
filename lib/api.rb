require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'lib/config'

#TODO:
#add config.yml / ensure that there is a db connection
#add function to return page count
#handle put, post, delete requests ('/:model/:id')
##validate which columns can be changed / are needed
#handle parametrized requests (do this in a generic way, which means allow every parameter which is a table column of the model too)
##add more parameters like limit

	set :root, APP_ROOT

	get '/' do
		#TODO: throw other error her, maybe a help message
		throw_error 405
	end

	#sync script for data from leipzig.de	
	get '/sync' do
		throw_error 405 if params['json'].nil?
		TempSync.create(:json => params['json'])
		output({"notice" => "record is created"})
	end

	#request a list in rest/rails style
	get '/:model' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate params, true
		
		#Datatable.set_table_name("data_#{params[:model]}")
		puts params[:model].singularize.capitalize
		output params[:model].singularize.capitalize.constantize.all(:select => only_permitted_columns, :limit => params[:limit], :offset => params[:page]), params[:format]
	end

	#per model requests
	#create
	post '/:model' do
		#TODO:
		#	How to handle db errors (required fields, foreign keys)?
		#	sanitize post data
		#	if user wants to add attributes he is not allowed to, throw an error (is currently just ignored)
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate params
		data = params[:model].singularize.capitalize.constantize.new(create_input_data)
		if(data.save(:validate=>false)) #TODO: define validation rules
			output({"notice" => "record is saved with ID=#{data.id}"}) #TODO substitute "id" with pk
		else
			output({"error" => "Couldn\'t save record"})
		end
	end

	#read
	get '/:model/:id' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate params, false, true
		
		if(params[:model].singularize.capitalize.constantize.exists?(params[:id]))
			output params[:model].singularize.capitalize.constantize.find(params[:id], :select => only_permitted_columns), params[:format]
		else
			output({"warning" => "Couldn\'t find record with ID=#{params[:id]}"})
		end
	end

	#update
	put '/:model/:id' do
		#TODO: see "post"
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate params, false, true
		
		if(params[:model].singularize.capitalize.constantize.exists?(params[:id]))
			# TODO: use update, if validation works
			#puts params[:model].singularize.capitalize.constantize.update(params[:id], create_input_data)
			data = params[:model].singularize.capitalize.constantize.find(params[:id])
			create_input_data.each do |column,value|
				data[column] = value
			end
			if(data.save(:validate=>false))
				output({"notice" => "record is updated with ID=#{params[:id]}"})
			else
				output({"error" => "Couldn\'t update record with ID=#{params[:id]}"})
			end
		else 
			output({"warning" => "Couldn\'t find record with ID=#{params[:id]}"})
		end
		
	end

	#delete
	delete '/:model/:id' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate params, false, true
		
		if(params[:model].singularize.capitalize.constantize.delete(params[:id]) == 1)
			output({"notice" => "Deleted record with ID=#{params[:id]}"})
		else
			output({"warning" => "Couldn\'t find record with ID=#{params[:id]}"})
		end
	end

