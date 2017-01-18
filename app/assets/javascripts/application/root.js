
var logo_height, logo_width;

$( document ).ready(function() {
	if($('body.root.index').length == 0)
		return;
	logo_height = $(".logo-wrapper .logo_image").height();
	logo_width = $(".logo-wrapper .logo_image").width();
	place_logo_text();
	logo_change();
});

function logo_change() {
	$(window).resize(function(){
		if($('body.root.index').length == 0)
			return;
		var new_height = $(".logo-wrapper .logo_image").height();
		var new_width = $(".logo-wrapper .logo_image").width();

		if (new_width != logo_width || new_height != logo_height) {
			logo_height = new_height;
			logo_width = new_width;
			place_logo_text();
		}
	});
}

function place_logo_text() {
	var font_size = parseInt($(".logo-wrapper .logo-back-text").css('font-size'));
	if(logo_height < 150) {
		font_size = font_size / 3 
	} else {
		font_size = font_size / 4
	}
	var top = logo_height/2 - font_size;
	$(".logo-wrapper .logo-back-text").css({'top': top  + 'px'});
}
