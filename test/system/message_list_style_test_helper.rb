# frozen_string_literal: true

module MessageListStyleTestHelper
  private

  # メッセージ表示スタイルのCookie値を設定する
  #
  # テスト用のため有効期限を60秒と短くしている。
  #
  # @param [String] style スタイルを表す文字列。
  # @see https://developer.mozilla.org/ja/docs/Web/API/Document/cookie#write_a_new_cookie
  def set_message_list_style(style)
    execute_script(<<~JS)
      document.cookie = "message_list_style=#{style}; max-age=60";
    JS
  end

  # メッセージ表示スタイルのCookie値をリセットする
  # @see https://developer.mozilla.org/ja/docs/Web/API/Document/cookie#write_a_new_cookie
  def reset_message_list_style_in_cookie
    execute_script(<<~JS)
      document.cookie = "message_list_style=; max-age=0";
    JS
  end

  # メッセージ表示スタイルのCookie値を取得する
  # @see https://developer.mozilla.org/ja/docs/Web/API/Document/cookie#example_2_get_a_sample_cookie_named_test2
  def get_message_list_style_in_cookie
    execute_script(<<~JS)
      return document.cookie
                     .split("; ")
                     .find(row => row.startsWith("message_list_style"))
                     ?.split("=")[1];
    JS
  end
end
