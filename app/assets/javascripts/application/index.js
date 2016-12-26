
// A $( document ).ready() block.
$( document ).ready(function() {
	place_logo_text();
	logo_change();
});

function logo_change() {
	$( ".logo-wrapper").change(function() {
		place_logo_text()
	});
}

function place_logo_text() {
	var logo_height = $(".logo-wrapper .logo_image").height();
	var font_size = $(".logo-wrapper .logo-back-text").css('font-size');
	var top = logo_height/2 - parseInt(font_size)/4;
	$(".logo-wrapper .logo-back-text").css({'top': top  + 'px'});
	var padding_top = parseInt($(".logo-wrapper").css('padding-top'));
	$(".logo-wrapper .hover-text").css({'top': top + padding_top  + 'px'});

}
