source "http://rubygems.org"

gem "sinatra", "~> 1.1.0"
gem "activerecord", "~> 3.0.0", :require => "active_record"
gem "json", "~> 1.5.1"
gem "authlogic"

group :development do
  gem "shotgun"
  gem "sqlite3-ruby", "~> 1.3.3", :require => "sqlite3"
end

group :production do
  gem "thin"
  gem "mysql", "~> 2.8.1"
end
