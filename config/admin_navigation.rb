# frozen_string_literal: true

# 管理画面のメニューの設定
#
# 設定の詳細は以下を参照：
# https://github.com/codeplant/simple-navigation/wiki/Configuration
SimpleNavigation::Configuration.run do |navigation|
  # アクティブな項目に適用されるクラス
  navigation.selected_class = 'active'

  # 自動ハイライト機能を有効にするか
  navigation.auto_highlight = true

  # 自動ハイライト機能がURL比較時にクエリパラメータやアンカーを無視するか。
  # 既定値は true。
  # navigation.ignore_query_params_on_auto_highlight = true
  # navigation.ignore_anchors_on_auto_highlight = true

  # 項目の下位パスにおいても項目がハイライトされるようにする
  navigation.highlight_on_subpath = true

  # 最上位レベルのナビゲーションの定義。
  # ナビゲーション部分は ul タグで囲まれ、各項目は li タグとして出力される。
  navigation.items do |primary|
    # ul タグの ID
    primary.dom_id = 'admin_nav'
    # ul タグのクラス
    primary.dom_class = %w(nav nav-pills nav-stacked)

    # 項目の options は lambda で定義し、項目ごとにこれを呼び出して新しく作る。
    # 新しく作らなければ、複数の項目が意図せず選択状態になってしまう。
    # これは、SimpleNavigation::Item#html_options() 内で、キー html に対応する
    # Hash が破壊的に変更され、HTML タグの class 属性に #selected_class が設定
    # されてしまうため。
    options = lambda {
      { html: { role: 'presentation' } }
    }

    primary.item(:admin_nav_status, fa_icon('info-circle', text: '現在の状態'),
                 admin_status_path, options[])
    primary.item(:admin_nav_users, fa_icon('user', text: '利用者'),
                 users_path, options[])
    primary.item(:admin_nav_settings, fa_icon('cog', text: '設定'),
                 settings_path, options[])
    primary.item(:admin_nav_channels, fa_icon('folder-open', text: 'チャンネル'),
                 admin_channels_path, options[])
  end
end
