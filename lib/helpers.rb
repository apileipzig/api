helpers do
	#validating every request
	#TODO: validate if model exists (or let the error "No permission(s) to do this." for now)
	#TODO: validate format
	#TODO: write a method which checks every parameter if it consists only of letters and digits, something like validate_only_aplhanumeric params
	def validate
		throw_error 401 if params[:api_key].nil?
		throw_error 400 unless params[:api_key].match(/^[A-Za-z0-9]*$/)
		
		#first check if a user exists, if not, forget about the rest of validation!
		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 401 if @user.nil?
		
		throw_error 400 unless params[:source].match(/^[A-Za-z0-9]*$/)
		throw_error 400 unless params[:model].match(/^[A-Za-z0-9]*$/)

		#TODO: connect permissions and user through the models (rails style)
		@permissions = @user.permissions.where(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model])
		throw_error 403 if @permissions.empty?

		throw_error 400 unless params[:id].match(/^[0-9]*$/) unless params[:id].nil?

		unless params[:offset].nil?
			throw_error 400 unless params[:offset].match(/^[0-9]*$/)
			params[:offset] =  params[:offset].to_i
		else
			params[:offset] = 0
		end

		unless params[:limit].nil?
			throw_error 400 unless params[:limit].match(/^[0-9]*$/)
			params[:limit] = params[:limit].to_i
			params[:limit] = params[:limit] > PAGE_SIZE ? PAGE_SIZE : params[:limit]
		else
			params[:limit] = PAGE_SIZE
		end
	end

	#error handling
	def throw_error code, options={}
		case code
			#TODO: add which parameter is wrong or missing
			when 400: halt code, (output :error => options[:message] ? options[:message] : "wrong parameter format.")
			#TODO: add more output information here, maybe a help message
			when 401: halt code, (output :error => options[:message] ? options[:message] : "Authentication failed.")
			when 404: halt code, (output :error => options[:message] ? options[:message] : "Not found.")
			when 403: halt code, (output :error => options[:message] ? options[:message] : "No permission(s) to do this.")
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
	def output options={} #, show_pages=false
		output = generate_output_data options

		if(options[:pagination])
			query_string = ""
			request.env['rack.request.query_hash'].each { |k,v| query_string += "#{k}=#{v}&" unless k == 'limit' or k == 'offset' }	
			url = request.env['rack.url_scheme'] +'://'+request.env['HTTP_HOST']+request.path+'?'+query_string+'offset=%d&limit=%d'
			paging = Hash.new
			pr = params[:offset] - params[:limit]
			pr = pr > 0 ? pr : 0
			paging[:previous] = sprintf(url,pr,params[:limit])
			ne = params[:offset] + params[:limit]
			paging[:next] = sprintf(url,ne,params[:limit]) if ne < params[:model].singularize.capitalize.constantize.count()
			output[:paging] = paging
		end

		if params[:format].nil? or params[:format] != "xml"
			# JSON
			content_type 'text/javascript', :charset => 'utf-8'
			#use pretty print for more readable output in browsers
			if request.env['HTTP_USER_AGENT'] =~ /(Firefox|Chrome|Chromium|Safari)/
				#very ugly
				JSON.pretty_generate(JSON.parse(output.to_json))
			else
				output.to_json
			end
		else
			# XML
			content_type 'text/xml', :charset => 'utf-8'
			options.to_xml(:skip_instruct => true, :skip_types => true)
		end
	end
	
	def generate_output_data options
		output = {}
######## this is generic for selecting everything from all associations
#		if options[:model]
#			additional_model_data = {}
#			options[:model].class.reflect_on_all_associations.map do |mac|
#				if mac.macro == :has_many or mac.macro == :has_and_belongs_to_many
#					#TODO: permissions and access restriction for this!
#					additional_model_data[mac.name] = options[:model].send(mac.name).select("id")
#				end
#			end
#			output = options[:model].attributes
#			output.merge!(additional_model_data)
#		end
########
######## this is for returning only an array of int's of id's
		if options[:model]
			output = options[:model].attributes
			options[:model].class.reflect_on_all_associations.map do |mac|
				if mac.macro == :has_many or mac.macro == :has_and_belongs_to_many
					#TODO: permissions and access restriction for this!
					output[mac.name] = options[:model].send(mac.name).select("id").map{|m| m.id}
				end
			end
		elsif options[:data]
########
			output[:data] = []
			options[:data].each do |d|
				dd = {}
				d.class.reflect_on_all_associations.map do |mac|
					if mac.macro == :has_many or mac.macro == :has_and_belongs_to_many
						#TODO: permissions and access restriction for this!
						dd[mac.name] = d.send(mac.name).select("id").map{|m| m.id}
					end
				end
				output[:data] << d.attributes << dd
			end
		elsif options[:error] or options[:success]
			output = options
		end
	output
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

