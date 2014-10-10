get '/' do
  @movies = Movie.all
  haml :"movies/index", :layout => :"layouts/application"
end

get '/movies/top' do
  @movies = Tmdb::Movie.top_rated
  haml :"movies/top", locals: {title: "Movie top 20"}, layout: :"layouts/application"
end

get '/movies/new' do
  @movies = Tmdb::Movie.upcoming
  haml :"movies/top", locals: {title: "Upcoming movies"}, layout: :"layouts/application"
end

get '/movie/:id' do
  @movie = Tmdb::Movie.detail(params[:id])
  @trailers = Tmdb::Movie.trailers(params[:id]).youtube.first(3)
  @torrents = TorrentApi.new(:pirate_bay, @movie.title).results

  haml :"movies/show", layout: :"layouts/application"
end

get '/movies/:id/play' do
  movie = Movie.find params[:id]
  if movie.movie_files.any?
    Thread.new{ movie.play }
    redirect '/player'
  else
    redirect '/'
  end
end

get '/search' do
  @movies = Tmdb::Movie.search(params[:query]).first(20)
  haml :"movies/top", locals: {title: "Search results"}, layout: :"layouts/application"
end

get '/movie/:id/progress' do
  movie = Movie.find(params[:id])
  if movie.progress == 100
    movie.update_attributes(completed: true)
  end

  haml "#{movie.progress}"
end

get '/movie/:id/download' do
  @movie = Tmdb::Movie.detail(params[:id])
  movie = Movie.where(identifier: @movie.id).first_or_create do |m|
    m.title = @movie.title
    m.poster_path = @movie.poster_path
  end

  path = "#{Application::DAEMON.get_config['download_location']}/#{@movie.title.parameterize}"
  daemon_id = Application::DAEMON.add_torrent_url(params[:torrent_uri], {"download_location" => path})
  movie.update_attributes(daemon_id: daemon_id, path: path) unless daemon_id.nil?

  redirect '/'
end

get '/player' do
  haml :"player/index", layout: :"layouts/application"
end

get '/assets/:path' do
  send_file File.open('assets/' + params[:path])
end

get '/action/:command' do
  Omxplayer.instance.action params[:command]
end

get '/daemon' do
@daemon = Application::DAEMON
  haml :"daemon/index", layout: :"layouts/application"
end

post '/daemon' do
  params.slice('download_location', 'stop_seed_ratio').each do |attr|
    Application::DAEMON.set_config(attr[0] => attr[1])
  end

  redirect '/daemon'
end
