helpers do
  def logger options={}
		options.merge!('ip' => request.env['REMOTE_ADDR'])
		options.merge!('request_path' => request.env['REQUEST_PATH'])
		options.merge!('query_string' => request.env['QUERY_STRING'])
    RequestLog.new(options).save(:validate => false)
  end
end
