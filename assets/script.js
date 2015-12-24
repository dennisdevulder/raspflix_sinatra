$(document).ready(function(){
  $('a.async').click(function(e){
    e.preventDefault();
    var target = $(e.currentTarget);
    $.ajax({
      url: target.attr('href'),
      method: 'GET'
    })
  });

  $('#select_genre select').change(function(e){
    e.preventDefault();
    window.location = $(this).val();
  });

  $('.select-torrent').click(function(e){
    e.preventDefault();
    var torrent_url = $('#torrent-value select').val();
    $.ajax({
      url: window.location.href + "/download?torrent_url=" + torrent_url,
      type: 'GET'
    })
  });

  $('ul.remote_actions a').click(function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      type: 'GET'
    })
  });

  $('.remote-btn').click(function(e){
    e.preventDefault();
    $('#remote').slideToggle();
  })
})
