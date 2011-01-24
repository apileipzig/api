helpers do
  def logger(token,tabelle)
	time = Time.now()
    log = Apilogging.new(:single_access_token => token, :tabelle => tabelle, :ip => request.env['REMOTE_ADDR'], :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"))
    log.save(:validate => false)
  end
end
