
(function() {
  $(document).on('page:change', function() {
    $('html').attr('lang', gon.locale);
    setupTabs();
  });

  $(document).on('ready page:change', function() {
  	var is_touch = is_touch_device();
    $('body').removeClass('touch').removeClass('no-touch');
  	if(is_touch) {
  		$('body').addClass('touch');
  	} else {
  		$('body').addClass('no-touch');
  	}

  });

})();

function is_touch_device() {
  return 'ontouchstart' in window        // works on most browsers 
      || navigator.maxTouchPoints;       // works on IE10/11 and Surface
};

