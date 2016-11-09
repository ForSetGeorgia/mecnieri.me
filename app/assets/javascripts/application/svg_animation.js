(function() {

  $(document).ready(function() {
    console.log('============== svg animation');
    $('a.category_image_animation').each(function(){
      console.log('creating animation for ' + $(this).attr('id'));
      console.log('- container = ' + $(this).data('container-id'));
      var svg_animation = new svgAnimation({
        canvas: new Snap('#' + $(this).attr('id')),
        svg: $(this).data('svg'),
        data: $(this).data('json'),
        id: $(this).data('container-id')
      });
    });
  });

})();
