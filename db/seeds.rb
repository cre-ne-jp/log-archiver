# 設定の初期値を設定する
Setting.find_or_create_by(id: 1) do |settings|
  # サイト名
  settings.site_title = 'IRC ログアーカイブ'
  # ホームページに表示する文章
  settings.text_on_homepage = 'このサイトでは IRC ログを保管しています。'
end
