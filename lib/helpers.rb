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
		
		throw_error 405 unless params[:source].match(/^[A-Za-z0-9]*$/)
		throw_error 405 unless params[:model].match(/^[A-Za-z0-9]*$/)

		#TODO: connect permissions and user through the models (rails style)
		@permissions = @user.permissions.where(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model])
		throw_error 403 if @permissions.empty?

		throw_error 405 unless params[:id].match(/^[0-9]*$/) unless params[:id].nil?

		unless params[:offset].nil?
			throw_error 405 unless params[:offset].match(/^[0-9]*$/)
			params[:limit] = PAGE_SIZE
			params[:offset] = params[:offset].to_i #* PAGE_SIZE	#first page is 0
		else
			throw_error 405 unless params[:limit].match(/^[0-9]*$/) unless params[:limit].nil?
			if params[:limit].nil?
				params[:limit] = PAGE_SIZE
			else
				params[:limit] = PAGE_SIZE if params[:limit].to_i > PAGE_SIZE
			end
			params[:offset] = 0
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
	def output options={}, show_pages=false

		if(show_pages)
			#TODO: find protocol (http vs. https)
			url = 'http://'+request.env['HTTP_HOST']+request.path+'?api_key=%s&offset=%d&limit=%d'
			url += 'format='+params[:format] unless params[:format].nil?
			paging = Hash.new
			pr = params[:offset] - params[:limit]
			#TODO: What to do if offset < PAGE_SIZE && offset > 0 ?
			paging['previous'] = sprintf(url,params[:api_key],pr,params[:limit]) if pr >= 0
			ne = params[:offset] + params[:limit]
			paging['next'] = sprintf(url,params[:api_key],ne,params[:limit]) if ne < params[:model].singularize.capitalize.constantize.count()
			options << [:paging => paging]
		end

		if params[:format].nil? or params[:format] != "xml"
			# JSON
			content_type 'text/javascript', :charset => 'utf-8'
			#use pretty print for more readable output in browsers
			if request.env['HTTP_USER_AGENT'] =~ /(Firefox|Chrome|Chromium|Safari)/
				#very ugly
				JSON.pretty_generate(JSON.parse(options.to_json))
			else
				options.to_json
			end
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
			columns += [per.column]
		end
		#add id to every model
		columns << "id"
	end

	def create_input_data
		data = Hash.new()
		@permissions.each do |per|
			data[per.column] = params[per.column] unless params[per.column].nil?
		end
		data
	end

  def logger
    RequestLog.create(:ip => request.env['REMOTE_ADDR'], :source => params[:source], :model => params[:model], :request_path => request.env['REQUEST_PATH'], :query_string => request.env['QUERY_STRING'], :method => get_action(request.env['REQUEST_METHOD']), :api_key => params[:api_key])
  end
end

