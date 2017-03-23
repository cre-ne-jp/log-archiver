/*global $, logArchiver */

(function () {
  'use strict';

  /**
   * @namespace
   * @memberof logArchiver
   */
  logArchiver.welcome = {
    index: function index() {
      var $dateTypeRadio = $('.date-type-radio');
      var $activeDateType = $('.date-type-radio:checked');
      var $byChannelDate = $('.by-channel-date');
      var $byChannelDateInput = $('input', $byChannelDate);

      /**
       * 日付のラジオボタンが押されたときの処理。
       * @param element {HTMLInputElement} 押されたラジオボタンの要素。
       * @param animation {boolean} 日付指定欄の表示・非表示のアニメーションを有効にするか。
       */
      function dateTypeRadioOnClick(element, animation) {
        var mustSpecifyDate = (element.value === 'specify');
        var showOrHide = mustSpecifyDate ? 'show' : 'hide';
        var duration;

        if (animation === undefined) {
          animation = false;
        }

        duration = animation ? 'fast' : 0;

        $byChannelDateInput.prop('required', mustSpecifyDate);
        $byChannelDate[showOrHide](duration);
      }

      $dateTypeRadio.click(function (e) {
        dateTypeRadioOnClick(e.target, true);
      });

      if ($activeDateType.length > 0) {
        dateTypeRadioOnClick($activeDateType[0], false);
      }
    }
  };
}());
