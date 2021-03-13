/* eslint no-console:0 */

import { Controller } from "stimulus";

class MessageFilterController extends Controller {
  static values = {
    // メッセージ一覧の表示スタイル
    messageListStyle: String,
    // 発言を表示するか
    showSpeeches: Boolean,
    // ニックネーム変更を表示するか
    showNicks: Boolean,
    // 参加・退出を表示するか
    showJoinsParts: Boolean,
  };

  static targets = [
    // 「発言」チェックボックス
    "showSpeeches",
    // 「ニックネーム変更」チェックボックス
    "showNicks",
    // 「参加・退出」チェックボックス
    "showJoinsParts",
    // メッセージ一覧（親要素：table、div）
    "messageList",
    // メッセージ全体
    "message",
    // 発言メッセージ
    "speechMessage",
    // ニックネーム変更メッセージ
    "nickMessage",
    // 参加・退出メッセージ
    "joinPartMessage",
    // 「表示する内容なし」のメッセージ
    "noMessageToShow",
  ];

  connect() {
    this.initializing = true;

    this.updateShowSpeeches();
    this.updateShowNicks();
    this.updateShowJoinsParts();

    this.initializing = false;
  }

  showSpeechesValueChanged() {
    this.setMessagesVisibility(this.speechMessageTargets, this.showSpeechesValue);
  }

  showNicksValueChanged() {
    this.setMessagesVisibility(this.nickMessageTargets, this.showNicksValue);
  }

  showJoinsPartsValueChanged() {
    this.setMessagesVisibility(this.joinPartMessageTargets, this.showJoinsPartsValue);
  }

  /**
   * 「発言」チェックボックスの値に合わせてメッセージの表示を更新する。
   */
  updateShowSpeeches() {
    this.showSpeechesValue = this.showSpeechesTarget.checked;
  }

  /**
   * 「ニックネーム変更」チェックボックスの値に合わせてメッセージの表示を更新する。
   */
  updateShowNicks() {
    this.showNicksValue = this.showNicksTarget.checked;
  }

  /**
   * 「参加・退出」チェックボックスの値に合わせてメッセージの表示を更新する。
   */
  updateShowJoinsParts() {
    this.showJoinsPartsValue = this.showJoinsPartsTarget.checked;
  }

  /**
   * メッセージの表示・非表示を更新する。
   * @param {HTMLElement[]} messages - メッセージ要素の配列。
   * @param {boolean} visible - メッセージを表示するか。
   */
  setMessagesVisibility(messages, visible) {
    // this.initializingが未定義の場合も呼ばれるので、falseとの厳密な比較が必要
    if (this.initializing !== false) {
      return;
    }

    messages.forEach(m => {
      m.hidden = !visible;
    });

    this.updateViews();
  }

  /**
   * 表示更新処理。
   */
  updateViews() {
    if (this.messageListStyleValue == "normal") {
      this.updateNormalStyleViews();
    }
  }

  /**
   * 通常表示の場合の表示更新処理。
   */
  updateNormalStyleViews() {
    // JavaScriptによる奇数行偶数行のスタイル設定のため、Bootstrapのクラスを除く
    this.messageListTarget.classList.remove("table-striped");

    // 表示されているメッセージの数
    let numOfVisibleMessages = 0;

    this.messageTargets.forEach((m) => {
      m.classList.remove("odd", "even");

      if (!m.hidden) {
        ++numOfVisibleMessages;

        // クラスの設定: 奇数 => ".odd"、偶数 => ".even"
        m.classList.add((numOfVisibleMessages & 1) ? "odd" : "even");
      }
    });

    // 表示されているメッセージが存在するか？
    const visibleMessagesExist = numOfVisibleMessages > 0;

    this.messageListTarget.hidden = !visibleMessagesExist;
    this.noMessageToShowTarget.hidden = visibleMessagesExist;
  }
}

export default MessageFilterController;
