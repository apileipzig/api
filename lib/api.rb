$:.unshift File.expand_path(File.dirname(__FILE__))

env = ENV['RACK_ENV'] || "development"

require 'rubygems'
require 'bundler'
Bundler.require(:default, env.to_sym)

settings.environment = env

require 'config'

#TODO:
##validate which columns can be changed / are needed
#handle parametrized requests (do this in a generic way, which means allow every parameter which is a table column of the model too)
#validate callbacks

  set :root, APP_ROOT

  get '/' do
    throw_error 400, :message => "Wrong url format."
  end

  get '/:source/?' do
    #TODO: throw other error her, maybe a help message
    throw_error 400
  end

  #request a list in rest/rails style
  get '/:source/:model/?' do
    logger
    validate

    conditions = {:select => only_permitted_columns}
    #only set limit and offset explicit
    conditions[:limit] = params[:limit] unless params[:limit].nil?
    conditions[:offset] = params[:offset] unless params[:offset].nil?
    #only set pagination if limit is set
    model = params[:model].singularize.capitalize.constantize
    data = model.respond_to?(:owned_by_or_public) ? model.owned_by_or_public(params[:api_key]).all(conditions) : model.all(conditions)
    output :data => data, :pagination => conditions[:limit] ? true : false
  end

  get '/:source/:model/search/?' do
    logger
    validate

    model = params[:model].singularize.capitalize.constantize
    # 1. search q in all permitted columns
    permitted_columns = only_permitted_columns
    conditions = [""]
    if !params[:q].nil? && params[:q].length > 0
      conditions[0] = "(" + permitted_columns.map{|k| "#{k} LIKE ?" }.join(" OR ") + ")"
      for i in 1..permitted_columns.length
        conditions[i] = "%#{params[:q]}%"
      end
    end

    # 2. search other paramters
    params.each do |k,v|
      if permitted_columns.include?(k) && v.to_s.length > 0
        comparator = model.columns.map{|c| c if c.name == k and c.type == :integer}.compact[0].nil? ? "LIKE" : "="
        if(conditions[0].length > 0)
          conditions[0] << " AND #{k} #{comparator} ?"
        else
          conditions[0] << "#{k} #{comparator} ?"
        end
        if comparator == "="
          conditions.push("#{v}")
        else
          conditions.push("%#{v}%")
        end
      end
    end

    # no output without parameters, otherwise it would return all datasets
    if conditions.size > 1
      c = {:select => permitted_columns, :conditions=>conditions}
      count = model.all(c).length
      c[:limit] = params[:limit] unless params[:limit].nil?
      c[:offset] = params[:offset] unless params[:offset].nil?
      data = model.respond_to?(:owned_by_or_public) ? model.owned_by_or_public(params[:api_key]).all(c) : model.all(c)
      output :data => data, :pagination => c[:limit] ? true : false, :count => count
    else
      output :error => "No search parameters."
    end
  end

  get '/:source/:model/count/?' do
    logger
    validate
    model = params[:model].singularize.capitalize.constantize
    data = model.respond_to?(:owned_by_or_public) ? model.owned_by_or_public(params[:api_key]).count : model.count
    output :count => data
  end

  #per model requests
  #create
  post '/:source/:model' do
    logger
    validate

    model = params[:model].singularize.capitalize.constantize.new(create_only_permitted_data)
    model.class.reflect_on_all_associations.map do |assoc|
      if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
        unless params[assoc.name].nil?
          assoc_array =[]
          assoc_array = params[assoc.name].split(",").map{ |n| n.to_i}
          #next two lines mean for example the following: Company.sub_branch_ids = [1,2,3]
          m = assoc.name.to_s.singularize + "_ids="
          model.send m.to_sym, assoc_array
        end
      end
    end

    model.owner = User.find_by_single_access_token(params[:api_key]) if model.respond_to?(:owned_by_or_public)

    if model.save
      output :success => {:message => "#{params[:model].singularize.capitalize} was saved with id = #{model.id}.", :id => model.id}
    else
      throw_error 404, :message => model.errors
    end
  end

  #read
  get '/:source/:model/:id' do
    logger
    validate

    begin
      scope = model = params[:model].singularize.capitalize.constantize
      # data = model.respond_to?(:owned_by_or_public) ? model.owned_by_or_public(params[:api_key]).find(params[:id], :select => only_permitted_columns) : model.find(params[:id], :select => only_permitted_columns)
      scope = model.owned_by_or_public(params[:api_key]) if model.respond_to?(:owned_by_or_public)
      data = scope.find(params[:id], :select => only_permitted_columns)
      output :model => data
    rescue Exception => e
      throw_error 404
    end
  end

  #update
  put '/:source/:model/:id' do
    logger
    validate

    begin
      model = params[:model].singularize.capitalize.constantize

      if model.respond_to?(:owned_by_or_public)
        data = model.owned_by_or_public(params[:api_key]).find(params[:id])
        throw_error 403 if @user != data.owner
      else
        data = model.find(params[:id])
      end

      data.class.reflect_on_all_associations.map do |assoc|
        if assoc.macro == :has_many or assoc.macro == :has_and_belongs_to_many
          unless params[assoc.name].nil?
            assoc_array =[]
            assoc_array = params[assoc.name].split(",").map{ |n| n.to_i}
            #next two lines mean for example the following: Company.sub_branch_ids = [1,2,3]
            m = assoc.name.to_s.singularize + "_ids="
            data.send m.to_sym, assoc_array
          end
        end
      end

      if data.update_attributes(create_only_permitted_data)
        output :success => {:message => "#{params[:model].singularize.capitalize} with id = #{params[:id]} was updated.", :id => data.id}
      else
        throw_error 404, :message => data.errors
      end
    rescue ActiveRecord::RecordNotFound => e
      throw_error 404
    rescue Exception => e
      throw_error 404, :message => {:message => e.to_s, :id => params[:id].to_i}
    end
  end

  #delete
  delete '/:source/:model/:id' do
    logger
    validate

    begin
      model = params[:model].singularize.capitalize.constantize

      if model.respond_to?(:owned_by_or_public)
        data = model.owned_by_or_public(params[:api_key]).find(params[:id])
        throw_error 403 if @user != data.owner
      else
        data = model.find(params[:id])
      end

      data.destroy
      output :success => {:message => "Deleted #{params[:model].singularize.capitalize} with id = #{params[:id]}.", :id => params[:id].to_i}
    rescue ActiveRecord::RecordNotFound => e
      throw_error 404
    rescue Exception => e
      throw_error 404, :message => {:message => e.to_s, :id => params[:id].to_i}
    end
  end

  #methods to catch all other request
  post '/*' do
    throw_error 400, :message => "Wrong url format."
  end

  get '/*' do
    throw_error 400, :message => "Wrong url format."
  end

  put '/*' do
    throw_error 400, :message => "Wrong url format."
  end

  delete '/*' do
    throw_error 400, :message => "Wrong url format."
  end

