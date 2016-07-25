function setupTabs() {
  function unselectSiblingTabListButtons($selectedTabListButton) {
    var $tabList = $selectedTabListButton.parents('.js-act-as-tab-list');
    var $tabListButtons = $tabList.find('.js-act-as-tab-list-button');

    $tabListButtons.removeClass('is-selected');
  }

  function unselectSiblingTabContentPanels($selectedTabContentPanel) {
    var $tabContent = $selectedTabContentPanel.parents('.js-act-as-tab-content');
    var $tabContentPanels = $tabContent.find('.js-act-as-tab-content-panel');

    $tabContentPanels.removeClass('is-selected');
  }

  $('.js-act-as-tab-list-button').click(function() {
    var $selectedTabListButton = $(this);
    var $selectedTabContentPanel = $('#' + $selectedTabListButton.data('selectsTabContentPanelId'));

    unselectSiblingTabListButtons($selectedTabListButton);
    unselectSiblingTabContentPanels($selectedTabContentPanel);

    $selectedTabListButton.addClass('is-selected');
    $selectedTabContentPanel.addClass('is-selected');
  });
}
