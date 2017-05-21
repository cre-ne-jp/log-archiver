module Channels::DaysHelper
  # メッセージ一覧のスタイルをCookieに保存する
  # @param [Symbol] style メッセージ一覧のスタイル
  # @param [Object] cookies Cookies
  # @return [void]
  def save_message_list_style(style, cookies)
    value = (style == :raw) ? 'raw' : 'normal'
    cookies[:message_list_style] = value
  end

  # メッセージ一覧のスタイルをCookieから取得する
  # @param [Object] cookies Cookies
  # @return [Symbol]
  def message_list_style(cookies)
    (cookies[:message_list_style] == 'raw') ? :raw : :normal
  end
end
