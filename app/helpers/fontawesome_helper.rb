module FontawesomeHelper
  # FontAwesome のアイコンを挿入する
  # bokmann/font-awesome-rails v4.7.0.7 (MIT License)
  # app/helpers/font_awesome/rails/icon_helper.rb
  # Copyright (c) 2012-2017 bokmann
  # log-archiver に必要な最低限の実装にするため、元のライブラリで使用可能な
  # 一部の機能は除いている。また、ソースコードを書き換えている。
  # 元のライブラリは FontAwesome 4.x 系をベースにしているが、このメソッドは
  # 5.x 系を利用すべく、リファレンスを元に改良している。
  # @see https://fontawesome.com/v5.15.2/how-to-use/on-the-web/referencing-icons/basic-use
  # @param [String] names アイコンの名前
  # @param [Hash] original_options オプション
  # @option original_options [Symbol] :style アイコンのスタイル
  # @option original_options [String] :class 追加する HTML/CSS クラス
  # @option original_options [String] :text アイコンの後に挿入するテキスト
  # @option original_options [Boolean] :right テキストをアイコンの前に挿入するフラグ
  # @return [String]
  def fa_icon(names = 'flag', original_options = {})
    options = original_options.deep_dup
    names = names.is_a?(Array) ? names : names.to_s.split(/\s+/)
    style =
      case(options.delete(:style))
      when :solid   then 'fas'
      when :regular then 'far'
      when :light   then 'fal'
      when :duotone then 'fad'
      when :brands  then 'fab'
      else               'fas'
      end

    classes = %w(fa)
    classes.push(style)
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
