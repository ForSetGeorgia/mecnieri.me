var container_width = 1400

$(document).ready(function() {
	categories_list_change();
	$(window).resize(function(){
		categories_list_change();
	});
});

function categories_list_change() {
	if ($(window).width() <= 1400 && $("body.root.experiments .exp-list li").hasClass('big') ) {
		$("body.root.experiments .exp-list li.big").removeClass('big').addClass('smaller prev-big');
	}
	else if(($(window).width() > 1400 && !$("body.root.experiments .exp-list li").hasClass('big') )) {
		$("body.root.experiments .exp-list li.prev-big").removeClass('smaller').addClass('big');
	}
}