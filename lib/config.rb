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

ActiveRecord::Base.establish_connection(YAML.load_file(APP_ROOT + '/database.yml'))

require APP_ROOT + '/lib/models.rb'
require APP_ROOT + '/lib/helpers.rb'

