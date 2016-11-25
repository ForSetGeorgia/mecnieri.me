var current_exp = 0;
var mobile_width = 1010;

(function() {

  $(document).ready(function() {
    
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

    $( window ).resize(function() {
        if($( window ).width() >= mobile_width){
          //if one of direction-items is already active
          if( $('.exp-directions').find('.exp-direction-item.active').length == 1) {
            return;
          }

          $('.exp-directions-buttons').show();
          $('.exp-directions').find('.exp-direction-item').removeClass('active');
          $('.exp-directions').find('.exp-direction-item:eq('+ current_exp +')').addClass('active');

        } else {
          mobile_experiments();
        }
    });

  });

})();

function mobile_experiments(){
    $('.exp-directions-buttons').hide();
    $('.exp-directions').find('.exp-direction-item').addClass('active');
}