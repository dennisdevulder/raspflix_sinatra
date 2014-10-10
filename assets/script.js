$(document).ready(function(){
  $('a.async').click(function(e){
    e.preventDefault();
    var target = $(e.currentTarget);
    $.ajax({
      url: target.attr('href'),
      method: 'GET'
    })
  });

  $('.toggle-torrents').click(function(e){
    e.preventDefault();
    $('.torrent_list').slideToggle();
  })

  window.setInterval(function(){
    var movies = []

    $.each($('.active_torrent'), function(index, obj){
      movies[index] = $(obj).attr('id')
    })

    if($('.active_torrent').size() > 0){
      $.ajax({
        url: '/movies/progress.json',
        method: 'GET',
        data: {"movie_ids":movies.toString()},
        success: function(response){
          $.each(JSON.parse(response), function(index, obj){
            var bar = $('#' + obj.id).children('div').children('div');
            if(obj.progress == 100.0){
              bar.removeClass('progress-bar-striped');
              bar.html('Ready');
            }else{
              bar.html(obj.progress + '%');
              bar.css('width', obj.progress + '%')
            }
          })
        }
      })
    }
  }, 3000)
})
