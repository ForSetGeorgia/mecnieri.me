(function() {
  $(document).on('page:change', function() {
    $('html').attr('lang', gon.locale);
    setupTabs();
  });
})();
