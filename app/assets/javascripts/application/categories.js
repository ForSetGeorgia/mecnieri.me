
var container_width = 1400;
var last_update_width;

$(document).on('ready', function() {
	last_update_width = -1;
	categories_list_change();
});

$(window).resize(function(){
	categories_list_change();
});	

function categories_list_change() {
	var window_width = $(window).width();
	if(last_update_width != -1 && last_update_width == window_width) {
		return;
	}
	if (window_width <= 1400 && $("body.root.experiments .exp-list li").hasClass('big') ) {
		$("body.root.experiments .exp-list li.big").removeClass('big').addClass('smaller prev-big');
		last_update_width = window_width;
	} else if((window_width > 1400 && !$("body.root.experiments .exp-list li").hasClass('big') )) {
		$("body.root.experiments .exp-list li.prev-big").removeClass('smaller').addClass('big');
		last_update_width = window_width;
	}
}