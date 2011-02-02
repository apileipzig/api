helpers do
	#validating every request
	#TODO: validate if model exists (or let the error "No permission(s) to do this." for now)
	#TODO: validate format
	#TODO: write a method which checks every parameter if it consists only of letters and digits, something like validate_only_aplhanumeric params
	def validate
		throw_error 401 if params[:api_key].nil?
		throw_error 405 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		
		#first check if a user exists, if not, forget about the rest of validation!
		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?
		
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)

		#TODO: connect permissions and user through the models (rails style)
		@permissions = Permission.find(:all, :joins=> :users, :conditions => {:access => get_action(request.env['REQUEST_METHOD']), :tabelle => params[:model], :users => { :id => @user.id } })
		throw_error 403 if @permissions.empty?

		throw_error 405 unless params[:id].match(/^[0-9]*$/) unless params[:id].nil?

		unless params[:page].nil?
			throw_error 405 unless params[:page].match(/^[0-9]*$/)
			params[:limit] = 10 # = page size
			params[:page] = params[:page].to_i * 10	#TODO: first page should be 1 or 0 ? (is 0)
		else
			throw_error 405 unless params[:limit].match(/^[0-9]*$/) unless params[:limit].nil?
			params[:limit] = 10 if params[:limit].to_i > 10 unless params[:limit].nil?
		end
	end

	#error handling
	def throw_error code
		case code
			#TODO: add more output information here, maybe a help message
			when 401: halt code, (output :error => "Authentication failed.")
			when 403: halt code, (output :error => "No permission(s) to do this.")
			#TODO: add which parameter is wrong or missing
			when 405: halt code, (output :error => "wrong parameter format.")
		end
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
	#TODO: add switch for browsers to display data nice like fb
	def output options={}
		puts options.inspect
		
		if params[:format].nil? or params[:format] != "xml"
			# JSON
			content_type 'text/javascript', :charset => 'utf-8'
			options.to_json()
		else
			# XML
			content_type 'text/xml', :charset => 'utf-8'
			options.to_xml(:skip_instruct => true, :skip_types => true)
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

  def logger options={}
		options.merge!('ip' => request.env['REMOTE_ADDR'])
		options.merge!('request_path' => request.env['REQUEST_PATH'])
		options.merge!('query_string' => request.env['QUERY_STRING'])
		options.merge!('method' => get_action(request.env['REQUEST_METHOD']))
    RequestLog.new(options).save(:validate => false)
  end
end

