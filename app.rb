require 'rubygems'
require 'sinatra'
require 'json'
require 'active_record'

load 'config.rb'
load 'models.rb'


# all models (API tables) belong here
get '/:model/' do

# get user
user = User.find(:first, :conditions => [ "single_access_token = ?", params[:key]])

# check if token is valid
if user == nil
	abort("wrong token")
end

# get permissions
permissions = Permission.find(:all, :joins=> :users, :conditions => {:task => "read", :table => params[:model], :users => { :id => user.id } }) 
if permissions.size == 0
	abort("no permissions found")
end

# create select based on permissions
columns = Array.new()
permissions.each do |per|
	columns += [per.column]
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
Datatable.set_table_name("data_#{params[:model]}")
results = Datatable.find(:all, :select => columns, :limit => limit, :conditions => where)

# create json from result
# FIXME: Why is "datatable" in JSON? How to remove it?
"#{results.to_json()}"

end
