require 'rubygems'
require 'sinatra'
#require 'json'
require 'active_record'
require 'memcache'

load 'config.rb'
load 'models.rb'
load 'helpers.rb'

# the routes
get '/' do
  'Sorry, this is not allowed'
end
get '/:model' do
  'Sorry, this is not allowed'
end

# all models (API tables) belong here
get '/:model/' do
	logger(params[:key],params[:model])

	# memcache
	@cache = MemCache.new("localhost:11211", :namespace => 'Sinatra/')
	buildCache()
	
	
	# get user
	user = User.find(:first, :conditions => [ "single_access_token = ?", params[:key]])

	# check if token is valid
	if user == nil
		abort("wrong token")
	end

	# get permissions
	permissions = Permission.find(:all, :joins=> :users, :conditions => {:access => "read", :tabelle => params[:model], :users => { :id => user.id } }) 
	if permissions.size == 0
		abort("no permissions found")
	end


	# check for paramters like size or columns
	if params[:size]	# returns length of table
		Datahelper = Datatable.clone()
		Datahelper.set_table_name("data_#{params[:model]}")
		results = Hash["#{params[:model]} size", Datahelper.count]
	elsif params[:columns] #return an array with columns
		results = Array.new()
		permissions.each do |permission|
			results += [permission.spalte]
		end
	else
		# create select based on permissions
		columns = Array.new()
		permissions.each do |per|
			columns += [per.spalte]
		end

		##### optional parameters #####
		# limit
		limit =  params[:limit]==nil ? 10 : params[:limit].to_i;
		where = Hash.new()
		# id (one or comma separated)
		if params[:id]!=nil
			where["id"] = params[:id].split(',')#to_i
		end

		##### fetch data #####
		# Clone Datatable to have a fresh Object every time
		Datahelper = Datatable.clone()
		Datahelper.set_table_name("data_#{params[:model]}")
		results = Datahelper.find(:all, :select => columns, :limit => limit, :conditions => where)
		
	end
	
	# create json or xmlfrom result
	if params[:output] == "xml"
		"#{results.to_xml(:skip_instruct => false, :skip_types => true)}"
	else
		"#{results.to_json()}"
	end
end
