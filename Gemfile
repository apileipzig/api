source "http://rubygems.org"

gem "sinatra"
gem "activerecord", "~> 3.0.6", :require => "active_record"
gem "json"
gem "authlogic"
gem "rake"
gem "shotgun"

group :development do
  gem "sqlite3"
end

group :test do
  gem "sqlite3"
  gem "rack-test", :require => "rack/test"
  gem "assert_json"
  gem "turn"
  gem "minitest"
  gem "shoulda-context"
  gem "factory_girl"
  gem "database_cleaner"
  gem "activesupport", :require => "active_support/testing/assertions"
end

group :production do
  gem "mysql2", "~> 0.2.0"
end
