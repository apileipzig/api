require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'lib/config'

#TODO:
##validate which columns can be changed / are needed
#handle parametrized requests (do this in a generic way, which means allow every parameter which is a table column of the model too)
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

	get '/:source' do
		#TODO: throw other error her, maybe a help message
		throw_error 405
	end

	#request a list in rest/rails style
	get '/:source/:model' do
		logger
		validate
		
		if !params[:pageCount].nil?
			output :pageCount => sprintf("%.f", (params[:model]).singularize.capitalize.constantize.count / PAGE_SIZE + 0.5)
		elsif !params[:itemCount].nil?
			output :itemCount => params[:model].singularize.capitalize.constantize.count
		else
			output :data => params[:model].singularize.capitalize.constantize.all(:select => only_permitted_columns, :limit => params[:limit], :offset => params[:page])
		end
	end

	#per model requests
	#create
	post '/:source/:model' do
		#TODO:
		#	if user wants to add attributes he is not allowed to, throw an error (is currently just ignored)
		logger
		validate

		data = params[:model].singularize.capitalize.constantize.new(create_input_data)
		if data.save
			output :success => "record is saved with ID=#{data.id()}"
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
			throw_error 404, :message => e.to_s
		end
	end

	#update
	put '/:source/:model/:id' do
		#TODO: see "post"
		logger
		validate
		
		begin
			data = params[:model].singularize.capitalize.constantize.find(params[:id])
			create_input_data.each do |column,value|
				data[column] = value
			end
			if data.save
				output :success => "record is updated with ID=#{params[:id]}"
			else
				throw_error 404, :message => data.errors
			end
		rescue Exception => e
			throw_error 404, :message => e.to_s
		end
	end

	#delete
	delete '/:source/:model/:id' do
		logger
		validate
		
		begin
			params[:model].singularize.capitalize.constantize.delete(params[:id])
			output :success => "Deleted record with ID=#{params[:id]}"
		rescue Exception => e
			throw_error 404, :message => e.to_s
		end
	end

