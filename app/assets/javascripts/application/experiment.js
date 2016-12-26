var current_exp = 0;
var mobile_width = 1010;
var on_mobile = false;

(function() {

  $(document).ready(function() {

    video_button_click();
    
    $('body.root.experiment .exp-directions .exp-directions-buttons').on('click', 'span', function(){
      //buttons prev and nex
      var $previous = $(this).closest('.exp-directions-buttons').find('.direction-previous');
      var $next = $(this).closest('.exp-directions-buttons').find('.direction-next');

      //current direction stuff
      var current_index = $(this).closest('.exp-directions-buttons').data('current-index');
      var $dirs = $(this).closest('.exp-directions').find('.exp-direction-item');
      var $current_dir = $(this).closest('.exp-directions').find('.exp-direction-item.active');
      var dir_index = $dirs.index($current_dir);

      if ($(this).data('type') == 'previous'){
        // previous button clicked
        // check to make sure there is an item before this
        // - if so, switch to it
        // - if not, do nothing
        if (dir_index > 0){
          $current_dir.removeClass('active').prev().addClass('active');
          // $(this).find('.exp-direction-item:eq(' + dir_index-1 + ')').addClass('active');
          $(this).closest('.exp-directions-buttons').attr('data-current-index', dir_index-1);

          // if this is now the first item, hide the previous link

          current_exp = dir_index - 1;
        } else {
          $current_dir.removeClass('active');
          $('.exp-directions').find('.exp-direction-item:eq('+ ($dirs.length- 1) +')').addClass('active');
          $(this).closest('.exp-directions-buttons').attr('data-current-index', $dirs.length- 1);

          current_exp =  $dirs.length- 1
        }

      }else if ($(this).data('type') == 'next'){
        // next button clicked
        // check to make sure there is an item after this
        // - if so, switch to it
        // - if not, do nothing
        if (dir_index < $dirs.length-1){
          $current_dir.removeClass('active').next().addClass('active');
          // $(this).find('.exp-direction-item:eq(' + dir_index+1 + ')').addClass('active');
          $(this).closest('.exp-directions-buttons').attr('data-current-index', dir_index+1);

          current_exp = dir_index + 1;

        } else {
          $current_dir.removeClass('active');
          $('.exp-directions').find('.exp-direction-item:eq('+ 0 +')').addClass('active');
          $(this).closest('.exp-directions-buttons').attr('data-current-index', 0);
          current_exp = 0;
        }
      }

      $next.addClass('active');
      $previous.addClass('active');

    })

    if($( window ).width() < mobile_width) {
      mobile_experiments();
    }

    act_on_resize();

  });

  $("#player").click();

})();

function video_button_click() {

}

function act_on_resize(){

    $( window ).resize(function() {
        if($( window ).width() >= mobile_width){
          not_mobile_experiments();

        } else {
          mobile_experiments();
        }
    });
}

function not_mobile_experiments(){
    if(!on_mobile) {
      return;
    }
    on_mobile = false;
    // $('#experiment_header_elements_wrap').append($('#exp-video')); 

    $('.exp-directions-buttons').show();
    $('.exp-directions').find('.exp-direction-item').removeClass('active');
    $('.exp-directions').find('.exp-direction-item:eq('+ current_exp +')').addClass('active');
}

function mobile_experiments(){
    if(on_mobile) {
      return;
    }
    on_mobile = true;
    // $('.inner-container').prepend($('#exp-video')); 
    $('.exp-directions-buttons').hide();
    $('.exp-directions').find('.exp-direction-item').addClass('active');
}


// 3. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    videoId: $("#player").attr("data-video-id"),
    events: {
      'onStateChange': onPlayerStateChange
    }
  });
}


// 5. The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
var done = false;
function onPlayerStateChange(event) {
  if (event.data == YT.PlayerState.PLAYING || event.data == YT.PlayerState.CUED ) {
      $("#exp-video").addClass("exp-video-bring-front");
  }
  else if( event.data == YT.PlayerState.ENDED || event.data == YT.PlayerState.PAUSED || event.data == YT.PlayerState.BUFFERING ){
    $("#exp-video").removeClass("exp-video-bring-front");
  }

  
}
