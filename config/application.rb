require "sinatra"
require "sinatra/activerecord"
require "haml"
require "themoviedb"
require "torrent_api"
require "deluge"
require "omxplayer"

class Application < Sinatra::Base
  Tmdb::Api.key('2433ca02f76e3becd9e1411ca69a028a')
  DAEMON = Deluge.new
  DAEMON.login 'admin', 'admin'

  require './models/movie.rb'
  require './config/routes'
end
