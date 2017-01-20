(function() {

  $(document).ready(function() {  
    if($('body.root.index').length == 0 && $('body.root.experiments').length == 0)
      return;
    $('a.category_image_animation').each(function(){
      var svg_animation = new svgAnimation({
        canvas: new Snap('#' + $(this).data('container-id') ),
        svg: $(this).data('svg'),
        data: $(this).data('json'),
        id: '#' + $(this).attr('id')
      });
    });
  });

})();
