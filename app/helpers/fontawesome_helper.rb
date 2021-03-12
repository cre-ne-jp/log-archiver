module FontawesomeHelper
  # FontAwesome のアイコンを挿入する
  # bokmann/font-awesome-rails v4.7.0.7 (MIT License)
  # app/helpers/font_awesome/rails/icon_helper.rb
  # Copyright (c) 2012-2017 bokmann
  # log-archiver に必要な最低限の実装にするため、元のライブラリで使用可能な
  # 一部の機能は除いている。また、ソースコードを書き換えている。
  # @param [String] names アイコンの名前
  # @param [Hash] original_options オプション
  # @option original_options [String] :class 追加する HTML/CSS クラス
  # @option original_options [String] :text アイコンの後に挿入するテキスト
  # @option original_options [Boolean] :right テキストをアイコンの前に挿入するフラグ
  # @return [String]
  def fa_icon(names = 'flag', original_options = {})
    options = original_options.deep_dup
    names = names.is_a?(Array) ? names : names.to_s.split(/\s+/)
    classes = %w(fa)
    classes.concat(names.map { |n| "fa-#{n}" })
    classes.concat(Array(options.delete(:class)))
    text = options.delete(:text)
    right = options.delete(:right)
    icon = content_tag(:i, nil, options.merge(:class => classes))

    return icon if text.blank?
    elements = [icon, ERB::Util.html_escape(text)]
    elements.reverse! if right
    safe_join(elements, ' ')
  end
end
