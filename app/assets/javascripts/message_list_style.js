/*global logArchiver, Cookies */

(function (ns) {
  'use strict';

  // Cookieの有効期限
  var COOKIE_EXPIRE_DATE = 14;
  // Cookieにおけるメッセージ表示スタイルのキー
  var MESSAGE_LIST_STYLE_KEY = 'message_list_style';

  /**
   * @namespace
   */
  ns.messageListStyle = {
    /**
     * 設定されたメッセージ表示のスタイルを取得する。
     * @return {string} 設定されたメッセージ表示のスタイル。
     */
    get: function () {
      var value = Cookies.get(MESSAGE_LIST_STYLE_KEY);
      return value === 'raw' ? 'raw' : 'normal';
    },

    /**
     * メッセージ表示スタイルを通常表示に設定する。
     */
    setNormal: function () {
      Cookies.set(MESSAGE_LIST_STYLE_KEY, 'normal',
                  { expires: COOKIE_EXPIRE_DATE });
    },

    /**
     * メッセージ表示スタイルを生ログに設定する。
     */
    setRaw: function () {
      Cookies.set(MESSAGE_LIST_STYLE_KEY, 'raw',
                  { expires: COOKIE_EXPIRE_DATE });
    }
  };
}(logArchiver));
