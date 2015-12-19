get '/' do
  @movies = Tmdb::Movie.upcoming
  haml :"movies/top", locals: {title: "Upcoming movies"}, layout: :"layouts/application"
end

get '/movies/top' do
  @movies = Tmdb::Movie.top_rated
  haml :"movies/top", locals: {title: "Movie top 20"}, layout: :"layouts/application"
end

get '/movie/:id' do
  @movie = Tmdb::Movie.detail(params[:id])
  @trailers = Tmdb::Movie.trailers(params[:id]).youtube.first(3)
  @torrents = Kat.quick_search(@movie.title)

  haml :"movies/show", layout: :"layouts/application"
end

get '/movies/:id/play' do
  movie = Movie.find params[:id]
  if movie.movie_files.any?
    movie.play
    redirect '/player'
  else
    redirect '/'
  end
end

get '/genres/:id' do
  if params[:page].to_i <= 1
    @movies = Tmdb::Genre.find(params[:id].capitalize).results
  else
    @movies = Tmdb::Genre.find(params[:id].capitalize).get_page(params[:page].to_i).results
  end
  haml :"movies/top", locals: {title: "#{params[:id].capitalize} movies"}, layout: :"layouts/application"
end

get '/genres/:id/more' do
  if params[:page].to_i <= 1
    @movies = Tmdb::Genre.find(params[:id].capitalize).get_page(2).results
  else
    @movies = Tmdb::Genre.find(params[:id].capitalize).get_page(params[:page].to_i).results
  end
  haml :"movies/async"
end

get '/search' do
  @movies = Tmdb::Movie.search(params[:query]).first(20)
  haml :"movies/top", locals: {title: "Search results"}, layout: :"layouts/application"
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

get '/series' do
  @movies = Tmdb::TV.popular
  haml :"series/index", locals: {title: "Top rated series"}, layout: :"layouts/series"
end

get '/series/:id' do
  @movie = Tmdb::TV.detail(params[:id])
  @torrents = Kat.quick_search("#{@movie.name} S01E01")

  haml :"series/show", layout: :"layouts/series"
end

get '/movie/:id/download' do
  system "stream #{params[:torrent_url]}"
  halt 200
end

get '/series/:serie_id/seasons/:id' do
  @movie = Tmdb::TV.detail(params[:serie_id])
  @season = Tmdb::Season.detail(@movie.id, params[:id])
  @torrents = TorrentApi.new(:pirate_bay, "#{@movie.name} S01E01").results

  haml :"series/show", layout: :"layouts/series"
end

get '/series/search' do
  @movies = Tmdb::TV.search(params[:query]).first(20)
  haml :"series/index", locals: {title: "Search results"}, layout: :"layouts/series"
end
