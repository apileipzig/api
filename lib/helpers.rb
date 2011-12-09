helpers do
  #validating every request
  #TODO: validate if model exists (or let the error "No permission(s) to do this." for now)

  def validate
    @permissions = []
    throw_error 403 if params[:api_key].nil?

    validate_only_alphanumeric

    #first check if a user exists, if not, forget about the rest of validation!
    @user = User.find(:first, :conditions => [ "single_access_token = ?", params[:api_key]])
    throw_error 403 if @user.nil?

    if request.env['REQUEST_URI'] =~ /\/count/
      @permissions = @user.permissions.where(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model], :access => "count")
    else
      @permissions = @user.permissions.where(:access => get_action(request.env['REQUEST_METHOD']), :source => params[:source], :table => params[:model])
    end

    throw_error 403 if @permissions.empty?

    validate_associations

    params[:offset] =  params[:offset].to_i unless params[:offset].nil?
    params[:limit] = params[:limit].to_i unless params[:limit].nil?
  end

  #check if parameters for associations are correct, e.g. sub_branches=1,2,3
  def validate_associations
    bad_params = []
    not_existing_assocs = []
    params[:model].singularize.capitalize.constantize.reflect_on_all_associations.map do |assoc|
      if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
        unless params[assoc.name].nil?
          bad_params << assoc.name.to_s unless params[assoc.name] =~ /^[0-9\,]*$/
          params[assoc.name].split(",").map do |n|
              if n.to_i == 0
                bad_params << assoc.name.to_s
              else
                not_existing_assocs << assoc.name.to_s + "=" + n unless assoc.class_name.singularize.capitalize.constantize.where(assoc.options[:conditions]).exists?(n)
              end
          end
        end
      end
    end
    throw_error 400, :message => "Wrong parameter format in #{bad_params.uniq.inspect.gsub('"','')}." if bad_params.length > 0
    throw_error 404, :message => "The following parameters don't exist: #{not_existing_assocs.uniq.inspect.gsub('"','')}." if not_existing_assocs.length > 0
  end

  #check every parameter if it consists only of alphanumeric chars
  def validate_only_alphanumeric
    bad_params = []
    params.each do |k,v|
      if k == 'limit' or k == 'offset'
        bad_params << k unless v.match(/^\d+$/) unless v.nil?
      else
        bad_params << k unless v.match(/^[^(\;\'\"\&\?\$)]*$/) unless v.nil?
      end
    end

    throw_error 400, :message => "Wrong parameter format in #{bad_params.inspect.gsub('"','')}." if bad_params.length > 0
  end

  #error handling
  def throw_error code, options={}
    case code
      when 400 then halt code, (output :error => options[:message] ? options[:message] : "Wrong parameter format.")
      #TODO: add more output information here, maybe a help message
      when 401 then halt code, (output :error => options[:message] ? options[:message] : "Authentication failed.")
      when 404 then halt code, (output :error => options[:message] ? options[:message] : "Not found.")
      when 403 then halt code, (output :error => options[:message] ? options[:message] : "No permission(s) to do this.")
    end
  end

  #map request_method to db access names
  def get_action request_method
    case request_method
      when 'POST' then 'create'
      when 'GET' then 'read'
      when 'PUT' then 'update'
      when 'DELETE' then 'delete'
    end
  end

  #generate resulting output
  def output options={}
    output = generate_output_data options

    if options[:pagination]
      count = options[:count] ? options[:count] : params[:model].singularize.capitalize.constantize.count
      #only add paging if the limit is smaller than the amount of all datarecords
      if params[:limit] < count
        output[:paging] = {}
        params[:offset] = 0 if params[:offset].nil?
        query_string = ""
        request.env['rack.request.query_hash'].each { |k,v| query_string += "#{k}=#{v}&" unless k == 'offset' }

        search = env['REQUEST_PATH'].match(/(\/search\/?)$/) ? Regexp.last_match(0) : ""

        url = API_URL+params[:source]+'/'+params[:model]+search+'?'+query_string

        #only next if limit+offset < count
        ne = params[:offset] + params[:limit]
        output[:paging][:next] = url+'offset='+ne.to_s unless ne > count

        #only previous if offset > 0
        if params[:offset] > 0
          pr = params[:offset] - params[:limit]
          if pr <= 0
            output[:paging][:previous] = url.chop!
          else
            output[:paging][:previous] = url+'offset='+pr.to_s
          end
        end
      end
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
#    if options[:model]
#      additional_model_data = {}
#      options[:model].class.reflect_on_all_associations.map do |mac|
#        if mac.macro == :has_many or mac.macro == :has_and_belongs_to_many
#          #TODO: permissions and access restriction for this!
#          additional_model_data[mac.name] = options[:model].send(mac.name).select("id")
#        end
#      end
#      output = options[:model].attributes
#      output.merge!(additional_model_data)
#    end
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
    else #if it's something else, just push it to the output
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

    #remove association data
    params[:model].singularize.capitalize.constantize.reflect_on_all_associations.map do |assoc|
        if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
          data.delete(assoc.name.to_s)
        end
    end

    throw_error 404, :message => "No permission to use parameters #{forbidden_params.inspect.gsub('"','')}." if forbidden_params.length > 0
    data
  end

  def logger
    unless request.env['HTTP_X_FORWARDED_FOR'].nil?
      ip = request.env['REMOTE_ADDR'] == "127.0.0.1" ? request.env['HTTP_X_FORWARDED_FOR'] : request.env['REMOTE_ADDR']
    else
      ip = request.env['REMOTE_ADDR']
    end
    RequestLog.create(:ip => ip, :user_agent => request.env['HTTP_USER_AGENT'], :source => params[:source], :model => params[:model], :request_path => request.env['REQUEST_PATH'], :query_string => request.env['QUERY_STRING'], :method => get_action(request.env['REQUEST_METHOD']), :api_key => params[:api_key])
  end
end

