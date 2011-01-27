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

	#request a list in rest/rails style
	get '/:model' do
		logger 'api_key' => params[:api_key], 'model' => params[:model]
		validate params
		
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
		validate_post params
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
		validate_get params
		
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
		validate_put params
		
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
		validate_delete params
		
		if(params[:model].singularize.capitalize.constantize.delete(params[:id]) == 1)
			output({"notice" => "Deleted record with ID=#{params[:id]}"})
		else
			output({"warning" => "Couldn\'t find record with ID=#{params[:id]}"})
		end
	end

	private

	#validating every request
	#TODO: validate if model exists (or let the error "No permission(s) to do this." for now)
	def validate params

		throw_error 401 if params[:api_key].nil?
		throw_error 405 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)
	
		if(!params[:page].nil?)
			throw_error 405 unless params[:page].match(/^[0-9]*$/)
			params[:limit] = 10 # = page size
			params[:page] = params[:page].to_i * 10	#TODO: first page should be 1 or 0 ? (is 0)
		else
			throw_error 405 unless params[:limit].match(/^[0-9]*$/) unless params[:limit].nil?
			params[:limit] = 10 if params[:limit].to_i > 10 unless params[:limit].nil?
		end

		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?
	
		#TODO: connect permissions and user through the models (rails style)
		@permissions = Permission.find(:all, :joins=> :users, :conditions => {:access => get_action(request.env['REQUEST_METHOD']), :tabelle => params[:model], :users => { :id => @user.id } })
		throw_error 403 if @permissions.empty?
	end

	def validate_get params

		throw_error 401 if params[:api_key].nil?
		throw_error 405 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:id].match(/^[0-9]*$/)
		
		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?
	
		@permissions = Permission.find(:all, :joins=> :users, :conditions => {:access => get_action(request.env['REQUEST_METHOD']), :tabelle => params[:model], :users => { :id => @user.id } })
		throw_error 403 if @permissions.empty?
	end

	def validate_post params

		throw_error 401 if params[:api_key].nil?
		throw_error 405 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)
		
		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?
	
		@permissions = Permission.find(:all, :joins=> :users, :conditions => {:access => get_action(request.env['REQUEST_METHOD']), :tabelle => params[:model], :users => { :id => @user.id } })
		throw_error 403 if @permissions.empty?
	end

	def validate_put params

		throw_error 401 if params[:api_key].nil?
		throw_error 405 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:id].match(/^[0-9]*$/)
		
		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?
	
		@permissions = Permission.find(:all, :joins=> :users, :conditions => {:access => get_action(request.env['REQUEST_METHOD']), :tabelle => params[:model], :users => { :id => @user.id } })
		throw_error 403 if @permissions.empty?
	end

	def validate_delete params
	
		throw_error 401 if params[:api_key].nil?
		throw_error 405 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:id].match(/^[0-9]*$/)

		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?

		@permissions = Permission.find(:first, :joins=> :users, :conditions => {:access => get_action(request.env['REQUEST_METHOD']), :tabelle => params[:model], :users => { :id => @user.id } })
		throw_error 403 if @permissions.nil?
	end

	#error handling
	def throw_error code
		#TODO: add more output information here, maybe a help message
		halt code, output({"error" => "Authentication failed"}) if code == 401
		halt code, output({"error" => "No permission(s) to do this."}) if code == 403
		#TODO: add which parameter is wrong or missing
		halt code, output({"error" => "wrong parameter format"}) if code == 405
	end

	#map request_method to db access names
	def get_action request_method
		case request_method
			when 'POST': 'create'
			when 'GET': 'read'
			when 'PUT': 'update'
			when 'DELETE': 'delete'
		end
	end

	#generate resulting output
	#output data
	#output data format
	def output *args
		if args[1] == "xml"
			content_type 'text/xml', :charset => 'utf-8'
			"#{args[0].to_xml(:skip_instruct => false, :skip_types => true)}"
		else
			#ensure that result is a json object everytime, not a json object or an array of json objects (like facebook)
			#FIXME: do this in a better and more reliable way
			h = Hash.new
			if args[0].is_a?(Array)
				h['data'] = args[0]
			else 
				h = args[0]
			end
			content_type 'text/plain', :charset => 'utf-8'
			"#{h.to_json()}"
		end
	end


	#specify only the colums we have rights to
	def only_permitted_columns
		columns = Array.new()
		@permissions.each do |per|
			columns += [per.spalte]
		end
		columns
	end


	def create_input_data
		data = Hash.new()
		@permissions.each do |per|
			data[per.spalte] = params[per.spalte] unless params[per.spalte].nil?
		end
		data
	end


