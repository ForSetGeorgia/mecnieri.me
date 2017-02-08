//= require cocoon
//= require_tree ./admin/

(function() {

  $(document).ready(function() {
    setupExperimentCocoon();
    setupExperimentMove();
    setupCategoryMove();
  });

  $(document).on('page:change', function() {
    RMRichTextArea.load();
  });

})();
