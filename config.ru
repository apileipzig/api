$:.unshift File.expand_path(File.dirname(__FILE__))
require 'lib/api.rb'
run Sinatra::Application

