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
    $.each($('.active_torrent'), function(index, obj){
      $.ajax({
        url: '/movie/'+ obj.id + '/progress',
        method: 'GET',
        success: function(response){
          var bar = $('#' + obj.id).children('div').children('div');
	  if(response == '100.0'){
	    bar.removeClass('progress-bar-striped');
	    bar.html('Ready');
	  }else{
	    bar.html(response + '%');
	    bar.css('width', response + '%')
	  }
	}
      })
    })
  }, 2000)
})
