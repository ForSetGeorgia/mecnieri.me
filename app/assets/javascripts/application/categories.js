
var container_width = 1400;
var last_update_width;

$(document).on('ready page:change', function() {
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

var hover_bind = function(e) {
	$(e.target).addClass('hover-effect');
	$(e.target).unbind('mouseenter', hover_bind);
	console.log('kuku');
}

function hover_effect_bind() {
	$("body.root.experiments .exp-list li .first-image").bind('mouseenter', hover_bind);
	$(document).unbind('ready page:change', hover_effect_bind);
}

function hover_effect() {
	$(document).bind('ready page:change', hover_effect_bind);
}
