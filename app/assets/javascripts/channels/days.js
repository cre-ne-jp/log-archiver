/*global logArchiver */

(function () {
  'use strict';

  /**
   * メッセージの表示を制御するコントローラ。
   * @constructor
   */
  function MessageVisibilityController() {
    this.categories = {};
  }

  /**
   * カテゴリを追加する。
   * @param {string} [name] カテゴリ名。
   * @param {Array} [$content] 対象となる jQuery オブジェクトの配列。
   * @return {MessageVisibilityController} this。
   */
  MessageVisibilityController.prototype.addCategory = function (name, $content) {
    this.categories[name] = {
      visible: true,
      content: $content
    };

    return this;
  };

  /**
   * カテゴリの表示・非表示を設定する。
   * @param {string} [name] カテゴリ名。
   * @param {boolean} [visible] 表示する場合は true、非表示にする場合は false。
   * @return {MessageVisibilityController} this。
   */
  MessageVisibilityController.prototype.setCategoryVisibility = function (name, visible) {
    var category = this.categories[name];

    if (category === undefined) {
      throw 'invalid category name: ' + name;
    }

    category.content[visible ? 'show' : 'hide']();
    category.visible = visible;

    return this;
  };

  /**
   * 表示されているメッセージが存在するかを返す。
   * @return {boolean} 表示されているメッセージが存在するか。
   */
  MessageVisibilityController.prototype.isThereAnyVisibleMessage = function () {
    var categories = this.categories;
    var category;

    for (var name in categories) {
      if (categories.hasOwnProperty(name)) {
        category = this.categories[name];

        if (category.visible && category.content.length > 0) {
          return true;
        }
      }
    }

    return false;
  };

  logArchiver.channels_days = {
    show: function show() {
      // 生ログを表示しているか
      var rawLog = ($('.raw-log').length > 0);

      // 発言の表示・非表示のチェックボックス
      var $showSpeeches = $('#show-speeches');
      // ニックネーム変更の表示・非表示のチェックボックス
      var $showNick = $('#show-nick');
      // 参加・退出の表示・非表示のチェックボックス
      var $showJoinPart = $('#show-join-part');

      // 通常表示タブ
      var $messageListStyleNormalTab = $('#message-list-style-normal-tab');
      // 生ログタブ
      var $messageListStyleRawTab = $('#message-list-style-raw-tab');

      // メッセージ表示スタイルのタブをクリックしたときのハンドラを設定する
      var setMessageListStyleTabClickHandlers = function () {
        if (rawLog) {
          $messageListStyleNormalTab.click(function () {
            logArchiver.messageListStyle.setNormal();
          });
        } else {
          $messageListStyleRawTab.click(function () {
            logArchiver.messageListStyle.setRaw();
          });
        }
      };

      // メッセージ一覧の表
      var $messageList = $('.message-list');

      // 表示するメッセージがないことの通知
      var $noMessageToShow = $('.no-message-to-show');

      // 発言
      var $speeches = $('.message-type-privmsg, .message-type-notice, .message-type-topic');
      // ニックネーム変更
      var $nicks = $('.message-type-nick');
      // 参加・退出
      var $joinPartMessages = $('.message-type-join, .message-type-part, .message-type-quit, .message-type-kick');

      var visibilityController = new MessageVisibilityController();

      // メッセージの表示・非表示を更新する関数を返す
      var updateVisibility = function (categoryName, $checkbox) {
        return function () {
          visibilityController.setCategoryVisibility(
            categoryName, $checkbox.prop('checked')
          );
        };
      }

      var updateSpeechesVisibility =
        updateVisibility('speeches', $showSpeeches);
      var updateNicksVisibility = updateVisibility('nicks', $showNick);
      var updateJoinPartMessagesVisibility =
        updateVisibility('joinPartMessages', $showJoinPart);

      // 表示するメッセージがないことの通知の表示・非表示を更新する
      var updateNoMessageToShowVisibility = function () {
        if (rawLog) {
          $noMessageToShow.hide();
          return;
        }

        var isThereAnyVisibleMessage =
          visibilityController.isThereAnyVisibleMessage();

        $messageList[isThereAnyVisibleMessage ? 'show' : 'hide']();
        $noMessageToShow[isThereAnyVisibleMessage ? 'hide' : 'show']();
      };

      // 表示されているメッセージの奇数行偶数行のクラスを振り直す
      var updateMessageListOddEven = function () {
        $('tr', $messageList).removeClass('odd even');
        $('tr:visible:odd', $messageList).addClass('odd');
        $('tr:visible:even', $messageList).addClass('even');
      };

      // 全体の表示を更新する
      var updateViews = function () {
        updateNoMessageToShowVisibility();

        // 行の可視性に表全体の可視性が継承されるため
        // 必ず表全体の可視性を変更してから偶数行・奇数行のスタイルを
        // 設定する
        updateMessageListOddEven();
      };

      // 表示・非表示のチェックボックスをクリックしたときの処理の関数を返す
      var onShowCheckboxClick = function (proc) {
        return function () {
          proc();
          updateViews();
        };
      };

      setMessageListStyleTabClickHandlers();

      visibilityController
        .addCategory('speeches', $speeches)
        .addCategory('nicks', $nicks)
        .addCategory('joinPartMessages', $joinPartMessages);

      $showSpeeches.click(onShowCheckboxClick(updateSpeechesVisibility));
      $showNick.click(onShowCheckboxClick(updateNicksVisibility));
      $showJoinPart.click(onShowCheckboxClick(updateJoinPartMessagesVisibility));

      // JavaScriptによる奇数行偶数行のスタイル設定のため、Bootstrapのクラスを除く
      $messageList.removeClass('table-striped');

      // 表示を初期化する
      updateSpeechesVisibility();
      updateNicksVisibility();
      updateJoinPartMessagesVisibility();

      updateViews();
    },

    index: function index() {
      var $dateListItems = $('#date-list > li');
      var $ctx = $('#speeches-chart');

      if ($ctx.length <= 0) {
        // グラフが存在しなければ何もしない
        return;
      }

      var dates = [];
      var labels = [];
      var values = [];
      var data = {
        labels: labels,
        datasets: [
          {
            label: '発言数',
            data: values,
            backgroundColor: '#E64A19'
          }
        ]
      };

      $dateListItems.each(function () {
        var $item = $(this);

        dates.push($item.data('date'));
        labels.push($item.data('day'));
        values.push(parseInt($item.data('num-of-speeches'), 10));
      });

      var speechesChart = new Chart($ctx, {
        type: 'bar',
        data: data,
        options: {
          scales: {
            yAxes: [{
              ticks: {
                beginAtZero: true
              }
            }]
          },

          legend: {
            display: false
          },

          tooltips: {
            callbacks: {
              title: function (tooltipItems, data) {
                var tooltipItem = tooltipItems[0];
                return dates[tooltipItem.index];
              }
            }
          },

          hover: {
            onHover: function (e, elements) {
              $ctx.css('cursor', elements[0] ? 'pointer' : 'default');
            }
          },

          animation: {
            duration: 400
          }
        }
      });

      // 棒グラフの棒をクリックしたときの処理
      $ctx.click(function (evt) {
        var activePoints = speechesChart.getElementsAtEvent(evt);
        var clicked;
        var dayPath;
        var href;

        if (activePoints.length > 0) {
          clicked = activePoints[0];

          // YYYY-mm-ddの9文字目から→dd
          dayPath = document.location.pathname + '/' + dates[clicked._index].slice(8);

          href = logArchiver.messageListStyle.get() === 'raw' ?
            (dayPath + '/?style=raw') : dayPath;
          document.location.href = href;
        }
      });
    }
  };
}());
