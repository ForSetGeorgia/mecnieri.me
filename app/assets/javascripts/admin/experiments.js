// update the sort order to be the index values
function updateTableIndex(tables){
  $(tables).each(function(){
    $(this).find('tr').each(function(index){
      $(this).find('td.js-has-sort-order input.sort-order').val(index);
    });
  });
}

// move a row in other tables to match the row that was just moved
function moveRowInOtherTables(current_tab_pane, table_data_type, original_index, move_direction){
  var $tab_panes = current_tab_pane.closest('.js-cocoon').find('.tab-pane');
  var original_locale = current_tab_pane.data('locale');

  // update the table in each tab pane
  $tab_panes.each(function(){
    // if the tab pane is not the original locale that already had the row moved, move it
    if ($(this).data('locale') != original_locale){
      var $rows = $(this).find('table[data-type="' + table_data_type + '"] tbody tr');
      var $row_to_move = $(this).find('table[data-type="' + table_data_type + '"] tbody tr:eq(' + original_index + ')');
      if ($row_to_move.length > 0){
        if (move_direction == 'up'){
          $row_to_move.insertBefore($rows[original_index-1]);
        }else{
          $row_to_move.insertAfter($rows[original_index+1]);
        }
      }
    }
  });
}




function setupExperimentCocoon(){
  // add ingredient
  $('.js-cocoon .tab-pane').on('cocoon:after-insert', 'table.table-ingredients', function(e, insertedItem) {
    var locale = $(this).data('locale');
    var page_locales = [];
    var row = $(insertedItem).clone();

    console.log('ingredient after insert');
    console.log(locale);

    // get all locales except the active one
    $('.js-cocoon .tab-pane').each(function(){if ($(this).data('locale') != locale){page_locales.push($(this).data('locale'))}});

    console.log(page_locales);

    // replace the locale and then add the row to the correct table
    for(var i=0;i<page_locales.length;i++){
      // update the inserted row with the appropriate locale
      $(row).html($(row).html().replace(new RegExp("_" + locale,"g"), '_' + page_locales[i]));
      // add the row
      $('.js-cocoon .tab-pane[data-locale="' + page_locales[i] + '"] table.table-ingredients tbody').append($(row));
    }

    // update the row directions
    updateTableIndex($(this).closest('.js-cocoon').find('.tab-pane table.table-ingredients tbody'));
  });

  // delete ingredient
  $('.js-cocoon .tab-pane').on('cocoon:before-remove', 'table.table-ingredients', function(e, deletedItem) {
    // get the index of the row being deleted so the same row for other languages can also be deleted
    var index = $(this).find('table.table-ingredients tbody tr').index(deletedItem);

    // mark this row in every table as deleted
    $('.js-cocoon .tab-pane table.table-ingredients tbody').each(function(){
      var row = $(this).find('tr')[index];
      // mark as deleted
      $(row).find('td:last input').val('true');
      // hide row
      $(row).fadeOut();
    });

  });

  // add direction
  $('.js-cocoon .tab-pane').on('cocoon:after-insert', 'table.table-directions', function(e, insertedItem) {
    var locale = $(this).data('locale');
    var page_locales = [];
    var row = $(insertedItem).clone();

    // get all locales except the active one
    $('.js-cocoon .tab-pane').each(function(){if ($(this).data('locale') != locale){page_locales.push($(this).data('locale'))}});

    // replace the locale and then add the row to the correct table
    for(var i=0;i<page_locales.length;i++){
      // update the inserted row with the appropriate locale
      $(row).html($(row).html().replace(new RegExp("_" + locale,"g"), '_' + page_locales[i]));
      // add the row
      $('.js-cocoon .tab-pane[data-locale="' + page_locales[i] + '"] table.table-directions tbody').append($(row));
    }

    // update the row directions
    updateTableIndex($(this).closest('.js-cocoon').find('.tab-pane table.table-directions tbody'));
  });

  // delete direction
  $('.js-cocoon .tab-pane').on('cocoon:before-remove', 'table.table-directions', function(e, deletedItem) {
    // get the direction of the row being deleted so the same row for other languages can also be deleted
    var index = $(this).find('table.table-directions tbody tr').index(deletedItem);

    // mark this row in every table as deleted
    $('.js-cocoon .tab-pane table.table-directions tbody').each(function(){
      var row = $(this).find('tr')[index];
      // mark as deleted
      $(row).find('td:last input').val('true');
      // hide row
      $(row).fadeOut();
    });
  });
}


// move table rows up and down to change order
function setupExperimentMove(){

  $('tr.nested-fields a.move-up').on('click', function(){
    var $row = $(this).closest('tr');
    var $data_type = $row.closest('table').data('type')

    // cannot use jquery next for cocoon puts hidden fields in between
    // tr tags, so have to look for next by hand
    var $rows = $row.closest('tbody').find('tr');
    var index = $rows.index($row);
    if (index > 0){
      $row.insertBefore($rows[index-1]);
    }


    // make the same movement in the other tables
    moveRowInOtherTables($row.closest('.tab-pane'), $data_type, index, 'up');

    // update the row directions
    updateTableIndex($(this).closest('.js-cocoon').find('.tab-pane table[data-type="' + $data_type + '"] tbody'));

    return false;
  });

  $('tr.nested-fields a.move-down').on('click', function(){
    var $row = $(this).closest('tr');
    var $data_type = $row.closest('table').data('type')

    // cannot use jquery next for cocoon puts hidden fields in between
    // tr tags, so have to look for next by hand
    var $rows = $row.closest('tbody').find('tr');
    var index = $rows.index($row);
    if (index < $rows.length-1){
      $row.insertAfter($rows[index+1]);
    }

    // make the same movement in the other tables
    moveRowInOtherTables($row.closest('.tab-pane'), $data_type, index, 'down');

    // update the row directions
    updateTableIndex($(this).closest('.js-cocoon').find('.tab-pane table[data-type="' + $data_type + '"] tbody'));

    return false;
  });

}