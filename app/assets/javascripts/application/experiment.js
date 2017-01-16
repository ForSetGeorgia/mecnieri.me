var current_exp = 0;
var mobile_width = 1010;
var on_mobile = false;
var arrow_change_width = 1010;
var big_arrow;
var video_loaded = false;

(function() {

  $(document).ready(function() {
    $('body.experiment_show .exp-directions .exp-directions-buttons').on('click', 'span', function(){
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


var video_load = function () {
    if(video_loaded)
      return;
    video_loaded = true;
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    window.onYouTubeIframeAPIReady = function () {
        window.player = new YT.Player('player', {
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
      else if( event.data == YT.PlayerState.ENDED || 
        event.data == YT.PlayerState.PAUSED || 
        event.data == YT.PlayerState.BUFFERING ){
        $("#exp-video").removeClass("exp-video-bring-front");
      }
    }
}


function youtube_api_call() {
    onYouTubeIframeAPIReady && onYouTubeIframeAPIReady();
}


function append_video() {
  if(!$("body.experiment_show #experiment_header_elements_wrap #exp-video #player").length) 
    return;
  video_loaded = false;
  $(document).bind('ready page:change',  video_load);
  $(document).bind('page:load', youtube_api_call);
}


function video_unbind_on_before_change() {
  $(document).on('page:before-change', function() {
      $(document).unbind('ready page:change',  video_load);
      $(document).unbind('page:load', youtube_api_call);
  });
}

video_unbind_on_before_change();


function experiment_updates() {
    $(document).bind('ready page:change',  add_video_space);
    $(document).bind('ready page:change',  change_navigation_color);
    $(document).bind('ready page:change',  place_arrow);
    $(window).bind('resize',  place_arrow);
    $(window).bind('scroll',  change_navigation_color);
}

function experiment_unbinds() {
  $(document).on('page:before-change', function() {
      $(document).unbind('ready page:change',  add_video_space);
      $(document).unbind('ready page:change',  change_navigation_color);
      $(document).unbind('ready page:change',  place_arrow);
      $(window).unbind('resize',  place_arrow);
      $(window).unbind('scroll',  change_navigation_color);
  });
}

experiment_unbinds();

function add_video_space() {
    if(!$("body.experiment_show #experiment_header_elements_wrap #exp-video").length) 
      return;
    $("body.experiment_show main .inner-container").addClass('video-space');
}

function change_navigation_color() {
    if(!$("body.experiment_show").length)
      return;
    
    var nav_offset = $("body.experiment_show .experiment-nav").offset().top;
    var inner_offest = $("body.experiment_show .inner-container-wrap").offset().top;
    
    if(nav_offset < inner_offest && !$("body.experiment_show .experiment-nav").hasClass('on-top')) {
        $("body.experiment_show .experiment-nav").addClass('on-top');
    }

    else if(nav_offset >= inner_offest && $("body.experiment_show .experiment-nav").hasClass('on-top')) {
        $("body.experiment_show .experiment-nav").removeClass('on-top');
    }
}

function place_arrow(first) {
    var selected_category  = $('body.root.experiment .primary-header .experiment-selected-category');
    var top_space = selected_category.position().top + selected_category.height() + 10;
    $('body.root.experiment .primary-header .arrow').css({'top' : top_space + 'px'});
}

