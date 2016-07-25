//= require cocoon
//= require_tree ./admin/

(function() {

  $(document).on('page:change', function() {
    RMRichTextArea.load();
  });

})();
