/*global logArchiver */

(function () {
  'use strict';

  logArchiver.channels_days = {
    show: function show() {
      // 生ログを表示しているか
      var rawLog = ($('.raw-log').length > 0);

      // 通常表示タブ
      var $messageListStyleNormalTab = $('#message-list-style-normal-tab');
      // 生ログタブ
      var $messageListStyleRawTab = $('#message-list-style-raw-tab');

      // メッセージ表示スタイルのタブをクリックしたときのハンドラを設定する
      if (rawLog) {
        $messageListStyleNormalTab.click(function () {
          logArchiver.messageListStyle.setNormal();
        });
      } else {
        $messageListStyleRawTab.click(function () {
          logArchiver.messageListStyle.setRaw();
        });
      }
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
          document.location.href = dayPath;
        }
      });
    }
  };
}());
