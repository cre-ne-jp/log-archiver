# 設定の初期値を設定する
Setting.find_or_create_by(id: 1) do |settings|
  # サイト名
  settings.site_title = 'IRC ログアーカイブ'
  # ホームページに表示する文章
  settings.text_on_homepage = 'このサイトでは IRC ログを保管しています。'
end

# 利用者の初期値を設定する
User.find_or_create_by(username: 'root') do |user|
  user.password = 'log_archiver'
  user.password_confirmation = 'log_archiver'
end

# ダミーのIRCユーザーを設定する
IrcUser.find_or_create_by(id: 1) do |irc_user|
  irc_user.user = 'dummy'
  irc_user.host = 'irc.example.net'
end
