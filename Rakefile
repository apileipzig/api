$:.unshift File.expand_path(File.dirname(__FILE__))

require 'active_record'
require 'authlogic'

require 'tasks/db'
require 'tasks/permissions'

require 'rake'
require 'rake/testtask'

desc "Run all tests"
Rake::TestTask.new do |t|
  t.name = "test:all"
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb','test/models/*_test.rb']
  t.ruby_opts = ['-r test_helper']
end

#alias shortcut
task :test => 'test:all'

desc "Run all model tests"
Rake::TestTask.new do |t|
  t.name = "test:models"
  t.libs << "test"
  t.test_files = FileList['test/models/*_test.rb']
  t.ruby_opts = ['-r test_helper']
end
