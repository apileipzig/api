require 'active_record'
require 'authlogic'

require 'tasks/db'
require 'tasks/permissions'

require 'rake'
require 'rake/testtask'


desc "Run all tests"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.ruby_opts = ['-r test_helper']
end

