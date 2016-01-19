require 'bundler/setup'
require "sinatra"
set :server, 'thin'
require "sinatra/activerecord"
require "sinatra/flash"

require "haml"
require "json"
require "themoviedb"
require "kat"
require "./patch/kat.rb"
require "omxplayer"
require 'open_uri_redirections'

require 'socket'

Omxplayer.class_eval do
  def open(filename)
    @filename = filename
    system "omxplayer -o hdmi -r \"#{filename}\" < /tmp/omxpipe &"
    action(:start)
  end

  def stream(torrent_url)
    system "stream_omxplayer #{torrent_url}"
  end
end

class Application < Sinatra::Base
  enable :sessions
  Tmdb::Api.key('2433ca02f76e3becd9e1411ca69a028a')
  Omxplayer.instance

  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    system("./bin/gen '#{s.addr.last}:4567'")
  end

  Socket.do_not_reverse_lookup = orig


  require './models/movie.rb'
  require './config/routes'
end
