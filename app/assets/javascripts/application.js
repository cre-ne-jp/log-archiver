// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require js.cookie
//= require Chart.min
//= require log_archiver
//= require message_list_style
//= require_tree .

/*global logArchiver */

/**
 * コントローラ名からオブジェクトを取得してフックを実行する。
 * @see http://qiita.com/naoty_k/items/d490b456e0f385942be8
 */
$(function () {
  'use strict';

  var $body = $('body');
  var controller = $body.data('rails-controller').replace(/\//, '_');
  var action = $body.data('rails-action');
  var activeController = logArchiver[controller];

  if (activeController !== undefined) {
    if ($.isFunction(activeController[action])) {
      activeController[action]();
    }
  }
});
