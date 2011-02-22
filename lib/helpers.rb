helpers do
	#validating every request
	#TODO: validate if model exists (or let the error "No permission(s) to do this." for now)
	#TODO: validate format
	#TODO: write a method which checks every parameter if it consists only of letters and digits, something like validate_only_aplhanumeric params
	def validate
		throw_error 403 if params[:api_key].nil?
		
		validate_only_alphanumeric
		validate_associations
		
		#first check if a user exists, if not, forget about the rest of validation!
		@user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
		throw_error 403 if @user.nil?
		
		@permissions = @user.permissions.where(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model])
		throw_error 403 if @permissions.empty?

		unless params[:offset].nil?
			params[:offset] =  params[:offset].to_i
		else
			params[:offset] = 0
		end

		unless params[:limit].nil?
			params[:limit] = params[:limit].to_i
			params[:limit] = params[:limit] > PAGE_SIZE ? PAGE_SIZE : params[:limit]
		else
			params[:limit] = PAGE_SIZE
		end
	end

	#check if parameters for associations are correct, e.g. sub_branches=1,2,3
	def validate_associations
		bad_params = []
		not_existing_assocs = []
		params[:model].singularize.capitalize.constantize.reflect_on_all_associations.map do |assoc|
			if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
				unless params[assoc.name].nil?
					bad_params << assoc.name.to_s unless params[assoc.name] =~ /^[0-9\,]+$/
					params[assoc.name].split(",").map do |n|
							if n.to_i == 0
								bad_params << assoc.name.to_s
							else
								not_existing_assocs << assoc.name.to_s + "=" + n unless assoc.class_name.singularize.capitalize.constantize.exists?(n)
							end
					end
				end
			end
		end
		throw_error 400, :message => "wrong parameter format in #{bad_params.uniq.inspect.gsub('"','')}." if bad_params.length > 0
		throw_error 404, :message => "following parameters don't exist: #{not_existing_assocs.uniq.inspect.gsub('"','')}." if not_existing_assocs.length > 0
	end

	#check every parameter if it consists only of alphanumeric chars	
	def validate_only_alphanumeric
		bad_params = []
		params.each do |k,v|
			#FIXME: for datetime add "-" and ":"
			if k == 'limit' or k == 'offset'
				bad_params << k unless v.match(/^\d+$/) unless v.nil?
			else
				bad_params << k unless v.match(/^[^(\;\'\"\&\?\$)]+$/) unless v.nil?
			end
		end
		throw_error 400, :message => "wrong parameter format in #{bad_params.inspect.gsub('"','')}." if bad_params.length > 0
	end

	#error handling
	def throw_error code, options={}
		case code
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
	def output options={}
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
				output.to_json + "\n"
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
					if @permissions.exists?(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model], :column => mac.name.to_s)
						#TODO: permissions and access restriction for this association! (not only displaying id)
						arr = options[:model].send(mac.name).select("id").map{|m| m.id}
						output[mac.name] = arr if arr.length > 0
					end
				end
			end
		elsif options[:data]
########
			output[:data] = []
			options[:data].each do |d|
				dd = {}
				d.class.reflect_on_all_associations.map do |mac|
					if mac.macro == :has_many or mac.macro == :has_and_belongs_to_many
						if @permissions.exists?(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model], :column => mac.name.to_s)
							#TODO: permissions and access restriction for this association! (not only displaying id)
							arr = d.send(mac.name).select("id").map{|m| m.id}
							dd[mac.name] = arr if arr.length > 0
						end
					end
				end
				output[:data] << d.attributes.merge!(dd)
			end
		elsif options[:error] or options[:success]
			output = options
		end
	output
	end

	#specify only the colums we have rights to
	def only_permitted_columns
		columns = []
		@permissions.each do |per|
			columns << per.column
		end
		#add id to every model
		columns << "id"
		#remove association data
		params[:model].singularize.capitalize.constantize.reflect_on_all_associations.map do |assoc|
				if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
					columns.map!{|column| column if column != assoc.name.to_s}
				end
		end
		columns.compact.uniq
	end

	def create_only_permitted_data
		data = {}
		data_params = {}

		data_params.merge! params
		
		#ugly as hell and not agnostic for future parameters, which are not data
		#but no better idea for now :(
		data_params.delete("api_key")
		data_params.delete("model")
		data_params.delete("source")
		data_params.delete(:limit)
		data_params.delete(:offset)
		data_params.delete("id")

		forbidden_params =[]
		data_params.each do |k,v|
			if @permissions.exists?(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model], :column => k)
				data[k] = v
			else
				forbidden_params << k
			end
		end
		
		throw_error 404, :message => "No permission to use parameters #{forbidden_params.inspect.gsub('"','')}." if forbidden_params.length > 0
		data
	end

  def logger
    RequestLog.create(:ip => request.env['REMOTE_ADDR'], :source => params[:source], :model => params[:model], :request_path => request.env['REQUEST_PATH'], :query_string => request.env['QUERY_STRING'], :method => get_action(request.env['REQUEST_METHOD']), :api_key => params[:api_key])
  end
end

