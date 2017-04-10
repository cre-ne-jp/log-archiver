/*global $, logArchiver */

(function () {
  'use strict';

  logArchiver.channels_days = {
    show: function show() {
      // 発言の表示・非表示のチェックボックス
      var $showSpeeches = $('#show-speeches');
      // ニックネーム変更の表示・非表示のチェックボックス
      var $showNick = $('#show-nick');
      // 参加・退出の表示・非表示のチェックボックス
      var $showJoinPart = $('#show-join-part');

      var $messageList = $('.message-list');

      // 発言
      var $speeches = $('.message-type-privmsg, .message-type-notice, .message-type-topic');
      // ニックネーム変更
      var $nicks = $('.message-type-nick');
      // 参加・退出
      var $joinPartMessages = $('.message-type-join, .message-type-part, .message-type-quit, .message-type-kick');

      // メッセージの表示・非表示を更新する関数を返す
      var updateVisibility = function ($target, $checkbox) {
        return function () {
          $target[$checkbox.prop('checked') ? 'show' : 'hide']();
        };
      }

      var updateSpeechesVisibility = updateVisibility($speeches, $showSpeeches);
      var updateNicksVisibility = updateVisibility($nicks, $showNick);
      var updateJoinPartMessagesVisibility = updateVisibility($joinPartMessages, $showJoinPart);

      // 表示されているメッセージの奇数行偶数行のクラスを振り直す
      var updateMessageListOddEven = function () {
        $('tr', $messageList).removeClass('odd even');
        $('tr:visible:odd', $messageList).addClass('odd');
        $('tr:visible:even', $messageList).addClass('even');
      };

      // 表示・非表示のチェックボックスをクリックしたときの処理の関数を返す
      var onShowCheckboxClick = function (proc) {
        // 表示・非表示を更新した後、奇数行偶数行のスタイルを更新する
        return function () {
          proc();
          updateMessageListOddEven();
        };
      };

      $showSpeeches.click(onShowCheckboxClick(updateSpeechesVisibility));
      $showNick.click(onShowCheckboxClick(updateNicksVisibility));
      $showJoinPart.click(onShowCheckboxClick(updateJoinPartMessagesVisibility));

      // JavaScriptによる奇数行偶数行のスタイル設定のため、Bootstrapのクラスを除く
      $messageList.removeClass('table-striped');

      // 表示を初期化する
      updateSpeechesVisibility();
      updateNicksVisibility();
      updateJoinPartMessagesVisibility();

      updateMessageListOddEven();
    }
  };
}());
