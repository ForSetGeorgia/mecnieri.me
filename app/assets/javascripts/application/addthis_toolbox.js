// // turbolinks addthis
// var initAdthis;

// initAdthis = function(){

//   // Remove all global properties set by addthis, otherwise it won't reinitialize
//   for (var i in window) {
//     if (/^addthis/.test(i) || /^_at/.test(i)) {
//       delete window[i];
//     }
//   }
//   window.addthis = null;

//   // Finally, load addthis
//   $.getScript("https://s7.addthis.com/js/300/addthis_widget.js#pubid=" + addthis_id, function(){
//     addthis.toolbox(".addthis_toolbox");
//   });

// };
