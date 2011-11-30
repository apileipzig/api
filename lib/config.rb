APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

module ActiveRecord
  class Base

    class << self
      alias :old_connection :connection
      def connection
        self.verify_active_connections!
        old_connection
      end
    end

  end
end

db_config = YAML.load_file(APP_ROOT + '/database.yml')[settings.environment.to_s]

ActiveRecord::Base.establish_connection(db_config)

require APP_ROOT + '/lib/models.rb'
require APP_ROOT + '/lib/helpers.rb'

PAGE_SIZE = 100
API_URL = 'http://www.apileipzig.de/api/v1/'
