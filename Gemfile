source "http://rubygems.org"

gem "sinatra"
gem "activerecord", "~> 3.0.6", :require => "active_record"
gem "json", "~> 1.5.1"
gem "authlogic"
gem "rake"

group :development do
  gem "shotgun"
  gem "sqlite3-ruby", "~> 1.3.3", :require => "sqlite3"
  gem "rack-test"
end

group :production do
  gem "thin"
  gem "mysql", "~> 2.8.1"
end
