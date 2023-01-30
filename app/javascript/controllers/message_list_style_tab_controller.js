/* eslint no-console:0 */

import { Controller } from "@hotwired/stimulus";
import MessageListStyle from "../message_list_style";

class MessageListStyleTabController extends Controller {
  static values = {
    // メッセージ一覧の表示スタイル
    messageListStyle: String,
  };

  static targets = [
    "normalTab",
    "rawTab",
  ];

  /**
   * メッセージ一覧を標準スタイルに設定する。
   */
  setStyleToNormal() {
    if (this.messageListStyleValue === "normal") {
      // 既に標準スタイルならば何もしない
      return;
    }

    MessageListStyle.setNormal();
  }

  /**
   * メッセージ一覧を生ログスタイルに設定する。
   */
  setStyleToRaw() {
    if (this.messageListStyleValue === "raw") {
      // 既に生ログスタイルならば何もしない
      return;
    }

    MessageListStyle.setRaw();
  }
}

export default MessageListStyleTabController;
