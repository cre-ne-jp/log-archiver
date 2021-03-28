/* eslint no-console:0 */

import Cookies from "js-cookie";

/** Cookieの有効期限。 */
const COOKIE_EXPIRE_DATE = 14;
/** Cookieにおけるメッセージ表示スタイルのキー。 */
const MESSAGE_LIST_STYLE_KEY = "message_list_style";

const MessageListStyle = {
  /**
   * 設定されたメッセージ表示のスタイルを取得する。
   * @return {string} 設定されたメッセージ表示のスタイル。
   */
  get() {
    const value = Cookies.get(MESSAGE_LIST_STYLE_KEY);
    return value === "raw" ? "raw" : "normal";
  },

  /**
   * メッセージ表示スタイルを通常表示に設定する。
   */
  setNormal() {
    Cookies.set(MESSAGE_LIST_STYLE_KEY, "normal",
                { expires: COOKIE_EXPIRE_DATE });
  },

  /**
   * メッセージ表示スタイルを生ログに設定する。
   */
  setRaw() {
    Cookies.set(MESSAGE_LIST_STYLE_KEY, "raw",
                { expires: COOKIE_EXPIRE_DATE });
  },
};

export default MessageListStyle;
