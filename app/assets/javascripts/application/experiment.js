(function() {

  $(document).ready(function() {
    $('body.root.experiment .exp-directions .exp-directions-buttons').on('click', 'span', function(){
      console.log('direction button clicked');
      var $previous = $(this).closest('.exp-directions-buttons').find('.direction-previous');
      var $next = $(this).closest('.exp-directions-buttons').find('.direction-next');
      var current_index = $(this).closest('.exp-directions-buttons').data('current-index');
      var $dirs = $(this).closest('.exp-directions').find('.exp-direction-item');
      var $current_dir = $(this).closest('.exp-directions').find('.exp-direction-item.active');
      var dir_index = $dirs.index($current_dir);
      console.log(this);
      console.log('current dir');
      console.log($current_dir);
      console.log('data type = ' + $(this).data('type') + '; current_index = ' + current_index + '; dir lenghth = ' + $dirs.length + '; dir_index = ' + dir_index);
      if ($(this).data('type') == 'previous'){
        console.log('- previous button clicked');
        // previous button clicked
        // check to make sure there is an item before this
        // - if so, switch to it
        // - if not, do nothing
        console.log(dir_index > 0);
        if (dir_index > 0){
          $current_dir.removeClass('active').prev().addClass('active');
          // $(this).find('.exp-direction-item:eq(' + dir_index-1 + ')').addClass('active');
          $(this).closest('.exp-directions-buttons').attr('data-current-index', dir_index-1);

          // if this is now the first item, hide the previous link
          if (dir_index-1 == 0){
            $previous.removeClass('active');
          }else{
            $previous.addClass('active');
          }
          $next.addClass('active');
        }
      }else if ($(this).data('type') == 'next'){
        console.log('- next button clicked');
        // next button clicked
        // check to make sure there is an item after this
        // - if so, switch to it
        // - if not, do nothing
        console.log(dir_index < $dirs.length-1);
        if (dir_index < $dirs.length-1){
          $current_dir.removeClass('active').next().addClass('active');
          // $(this).find('.exp-direction-item:eq(' + dir_index+1 + ')').addClass('active');
          $(this).closest('.exp-directions-buttons').attr('data-current-index', dir_index+1);

          // if this is now the last item, hide the previous link
          if (dir_index+1 == $dirs.length-1){
            $next.removeClass('active');
          }else{
            $next.addClass('active');
          }
          $previous.addClass('active');
        }
      }
    })
  });

})();
