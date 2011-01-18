require 'rubygems'
require 'sinatra'
require 'json'
require 'active_record'

load 'config.rb'
load 'models.rb'

# Define an error class
#class UsageError < Exception
#end
#error UsageError do
#	'Sorry, this is not allowd'
#end


# helpers
helpers do
	def logger(token,tabelle)
time = Time.now()
		log = Apilogging.new(:single_access_token => token, :tabelle => tabelle, :ip => request.env['REMOTE_ADDR'], :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"))
		log.save(false)
	end
end

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

# create json from result
"#{results.to_json()}"

end
