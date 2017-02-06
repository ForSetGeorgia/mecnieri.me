var fbRoot = null; 
var fbEventsBound = false;

function fb_load() {
	(function(d, s, id) {
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if (d.getElementById(id)) return;
	  js = d.createElement(s); js.id = id;
	  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.8&appId=" + facebook_id;
	  fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));

	if(!fbEventsBound) 
		fb_binds();
};

function fb_binds() {
	$(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', function(){
	    	if(FB != null){
	    	  FB.XFBML.parse();
	    	}
	    }
    );
    fbEventsBound = true;
}

function saveFacebookRoot(){
  if( $('#fb-root').length){
    fbRoot = $('#fb-root').detach();
  }
}

function restoreFacebookRoot(){
  if(fbRoot != null) {
  	if( $('#fb-root').length )
      $('#fb-root').replaceWith(fbRoot);
    else
      $('body').append(fbRoot);
  }
}
