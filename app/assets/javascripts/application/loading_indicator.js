// Shows and hides the loading indicator when users switch pages


$(document).on("page:before-change", function() {
  $(".loading-indicator").fadeIn();
});

$(document).on("page:change", function(){
  $(".loading-indicator").fadeOut();
});




// $(document).on("page:load, page:change", function() {
//   $(".loading-indicator").fadeOut();
// });
