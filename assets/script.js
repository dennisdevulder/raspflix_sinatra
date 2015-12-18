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

  $('.toggle-torrents').click(function(e){
    e.preventDefault();
    $('.torrent_list').slideToggle();
  })
})
