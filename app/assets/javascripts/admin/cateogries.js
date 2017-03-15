// update the sort order of the category
function setupCategoryMove(){

  function saveCategoryMove(url){
    $.ajax
     ({
        url: url,
        type: "POST",
        dataType: 'json'
     });
  }

  function moveCategoryRow(row, direction){
    var $rows = $('table.table-categories > tbody > tr');

    if ($rows.length > 0){
      var index = $rows.index(row);

      if (index != -1){
        if (direction == 'up' && index > 0 ){
          row.insertBefore($rows[index-1]);
        }else if (direction == 'down' && index < $rows.length){
          row.insertAfter($rows[index+1]);
        }        
      }
    }
  }

  $('table.table-categories').on('click', '.move-up', function(){
    saveCategoryMove($(this).data('url'));
    moveCategoryRow($(this).closest('tr'), 'up');
  });

  $('table.table-categories').on('click', '.move-down', function(){
    saveCategoryMove($(this).data('url'));
    moveCategoryRow($(this).closest('tr'), 'down');
  });

}
