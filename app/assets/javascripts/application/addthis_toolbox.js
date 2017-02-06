// turbolinks addthis
var initAdthis;

initAdthis = function(){
  if (gon.addthis_id){
    // Remove all global properties set by addthis, otherwise it won't reinitialize
    for (var i in window) {
      if (/^addthis/.test(i) || /^_at/.test(i)) {
        delete window[i];
      }
    }
    window.addthis = null;

    // Finally, load addthis
    $.getScript("https://s7.addthis.com/js/300/addthis_widget.js#pubid=" + gon.addthis_id, function(){
      addthis.toolbox(".addthis_toolbox");
    });
  }
};

$(document).on('ready, page:change', function() {
  initAdthis();
}) 