require 'bundler/setup'
require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

require "haml"
require "json"
require "themoviedb"
require "torrent_api"
require "omxplayer"
require "deluge"

require 'socket'

Omxplayer.class_eval do
  def open(filename)
    @filename = filename
    system "omxplayer -o hdmi -r \"#{filename}\" < /tmp/omxpipe &"
    action(:start)
  end
end

class Application < Sinatra::Base
  enable :sessions
  Tmdb::Api.key('2433ca02f76e3becd9e1411ca69a028a')
  DAEMON = Deluge.new
  DAEMON.login 'admin', 'admin'
  Omxplayer.instance

  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    puts "Connection available at  http://#{s.addr.last}:4567"
  end

  Socket.do_not_reverse_lookup = orig


  require './models/movie.rb'
  require './config/routes'
end
