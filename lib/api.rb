require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'lib/config'

#TODO:
#add function to return page count
##validate which columns can be changed / are needed
#handle parametrized requests (do this in a generic way, which means allow every parameter which is a table column of the model too)
##add more parameters like limit
#validate callbacks

	set :root, APP_ROOT

	get '/' do
		#TODO: throw other error her, maybe a help message
		throw_error 405
	end

	#sync script for data from leipzig.de	
	get '/sync' do
		throw_error 405 if params['json'].nil?
		if TempSync.create(:json => params['json'])
			output :success => "record created."
		else
			output :error => "record could not be created."
		end
	end

	#temp read
	get '/sync_read' do
		count = TempSync.all.length
		last = TempSync.last
		"anzahl der datensätze: #{count} <br /><br />letzter datensatz:<br/><br/>id: #{last.id}<br />json: #{last.json}"
	end

	#request a list in rest/rails style
	get '/:model' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate
		
		output :data => params[:model].singularize.capitalize.constantize.all(:select => only_permitted_columns, :limit => params[:limit], :offset => params[:page])
	end

	#per model requests
	#create
	post '/:model' do
		#TODO:
		#	How to handle db errors (required fields, foreign keys)?
		#	sanitize post data
		#	if user wants to add attributes he is not allowed to, throw an error (is currently just ignored)
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate

		data = params[:model].singularize.capitalize.constantize.new(create_input_data)
		if data.save #TODO: define validation rules
			output :success => "record is saved with ID=#{data.id}" #TODO substitute "id" with pk
		else
			output :error => "Couldn\'t save record"
		end
	end

	#read
	get '/:model/:id' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate
		
		if params[:model].singularize.capitalize.constantize.exists?(params[:id])
			output :model => params[:model].singularize.capitalize.constantize.find(params[:id], :select => only_permitted_columns)
		else
			output :error => "Couldn\'t find record with ID=#{params[:id]}"
		end
	end

	#update
	put '/:model/:id' do
		#TODO: see "post"
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate
		
		if params[:model].singularize.capitalize.constantize.exists?(params[:id])
			# TODO: use update, if validation works
			data = params[:model].singularize.capitalize.constantize.find(params[:id])
			create_input_data.each do |column,value|
				data[column] = value
			end
			if data.save
				output :success => "record is updated with ID=#{params[:id]}"
			else
				output :error => "Couldn\'t update record with ID=#{params[:id]}"
			end
		else 
			output :error => "Couldn\'t find record with ID=#{params[:id]}"
		end
	end

	#delete
	delete '/:model/:id' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate
		
		if params[:model].singularize.capitalize.constantize.delete(params[:id])
			output :success => "Deleted record with ID=#{params[:id]}"
		else
			output :error => "Couldn\'t find record with ID=#{params[:id]}"
		end
	end

