require "rubygems"
require "bundler"
Bundler.require(:test)

class Riot::Situation
  def app
    @app = Sinatra::Application
  end
end
