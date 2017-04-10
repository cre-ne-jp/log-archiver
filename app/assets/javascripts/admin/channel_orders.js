/*global $, logArchiver */

(function () {
  'use strict';

  function onUpdateChannelOrder(e, ui) {
    var item = ui.item;
    var params = {
      _method: 'PATCH',
      channel: {
        row_order_position: item.index()
      }
    };

    $.ajax({
      type: 'POST',
      url: item.data().sorturl,
      dataType: 'json',
      data: params
    });
  }

  function onStopChannelOrder(e, ui) {
    ui.item.effect('highlight');
  }

  logArchiver.admin_channel_orders = {
    show: function show() {
      $('#channels-sortable').sortable({
        axis: 'y',
        items: '.channels-sortable-item',
        update: onUpdateChannelOrder,
        stop: onStopChannelOrder
      });
    }
  };
}());
