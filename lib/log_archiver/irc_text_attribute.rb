# frozen_string_literal: true

module LogArchiver
  # IRCメッセージのテキストの属性を表すクラス
  #
  # IRCクライアントにおいてmIRC制御文字によって設定される属性を示す。
  # HTMLでの表現を想定して、`span` 開始タグに変換することができる。
  class IrcTextAttribute
    # @return [Boolean] 太字にするか
    attr_reader :bold
    # @return [Boolean] 下線を引くか
    attr_reader :underline
    # @return [Boolean] 斜体にするか
    attr_reader :italic
    # @return [Boolean] 打消線を引くか
    attr_reader :strikethrough
    # @return [Boolean] 等幅フォントにするか
    attr_reader :monospace
    # @return [Boolean] 文字色と背景色を反転するか
    attr_reader :reverse
    # @return [String] 文字色
    attr_reader :text_color
    # @return [String] 背景色
    attr_reader :bg_color
    # @return [String] 16進表記の文字色
    attr_reader :text_hex_color
    # @return [String] 16進表記の背景色
    attr_reader :bg_hex_color

    # 既定の色のコード
    DEFAULT_COLOR_CODE = 99

    def initialize
      @bold = false
      @underline = false
      @italic = false
      @strikethrough = false
      @monospace = false
      @reverse = false
      @text_color = DEFAULT_COLOR_CODE
      @bg_color = DEFAULT_COLOR_CODE
      @text_hex_color = nil
      @bg_hex_color = nil
    end

    # @param [IrcTextAttribute] other
    # @return [Boolean] 他の属性オブジェクトと同じ内容か比較した結果
    def ==(other)
      other.bold == @bold &&
        other.underline == @underline &&
        other.italic == @italic &&
        other.strikethrough == @strikethrough &&
        other.monospace == @monospace &&
        other.reverse == @reverse &&
        other.text_color == @text_color &&
        other.bg_color == @bg_color &&
        other.text_hex_color == @text_hex_color &&
        other.bg_hex_color == @bg_hex_color
    end

    # 2桁表記で文字色を設定する
    #
    # 16進表記の文字色はクリアされる。
    #
    # @param [Integer] value 新しい文字色
    def text_color=(value)
      @text_color = value
      @text_hex_color = nil
    end

    # 2桁表記で背景色を設定する
    #
    # 16進表記の背景色はクリアされる。
    #
    # @param [Integer] value 新しい背景色
    def bg_color=(value)
      @bg_color = value
      @bg_hex_color = nil
    end

    # 16進表記で文字色を設定する
    #
    # 2桁表記の文字色はクリアされる。
    #
    # @param [String] value 新しい文字色
    def text_hex_color=(value)
      @text_hex_color = value
      @text_color = DEFAULT_COLOR_CODE
    end

    # 16進表記で背景色を設定する
    #
    # 2桁表記の背景色はクリアされる。
    #
    # @param [String] value 新しい背景色
    def bg_hex_color=(value)
      @bg_hex_color = value
      @bg_color = DEFAULT_COLOR_CODE
    end

    # 太字設定を切り替える
    # @return [self]
    def toggle_bold!
      @bold = !@bold
      self
    end

    # 下線設定を切り替える
    # @return [self]
    def toggle_underline!
      @underline = !@underline
      self
    end

    # 斜体設定を切り替える
    # @return [self]
    def toggle_italic!
      @italic = !@italic
      self
    end

    # 打消し線設定を切り替える
    # @return [self]
    def toggle_strikethrough!
      @strikethrough = !@strikethrough
      self
    end

    # 等幅フォント設定を切り替える
    # @return [self]
    def toggle_monospace!
      @monospace = !@monospace
      self
    end

    # 色反転設定を切り替える
    # @return [self]
    def toggle_reverse!
      @reverse = !@reverse
      self
    end

    # 文字色および背景色をリセットする
    # @return [self]
    def reset_colors!
      @text_color = DEFAULT_COLOR_CODE
      @bg_color = DEFAULT_COLOR_CODE
      @text_hex_color = nil
      @bg_hex_color = nil

      self
    end

    # @return [Integer] 現在の2桁文字色
    def current_text_color
      @reverse ? @bg_color : @text_color
    end

    # @return [Integer] 現在の2桁背景色
    def current_bg_color
      @reverse ? @text_color : @bg_color
    end

    # @return [String] 現在の16進文字色
    def current_text_hex_color
      @reverse ? @bg_hex_color : @text_hex_color
    end

    # @return [String] 現在の16進背景色
    def current_bg_hex_color
      @reverse ? @text_hex_color : @bg_hex_color
    end

    # `span` タグを生成する
    #
    # 既定の属性の場合は text をそのまま返す。
    # 変更点があった場合は、対応する `span` タグで text を包んで返す。
    #
    # @param [String] text `span` タグで包むテキスト
    # @return [String] `span` タグで包まれたテキスト
    def span_tag(text)
      classes = [
        @bold ? 'mirc-bold' : nil,
        @italic ? 'mirc-italic' : nil,
        @underline ? 'mirc-underline' : nil,
        @strikethrough ? 'mirc-strikethrough' : nil,
        @monospace ? 'mirc-monospace' : nil,
        color_class('mirc-color', current_text_color),
        current_text_hex_color ? 'mirc-color-hex' : nil,
        color_class('mirc-bg', current_bg_color),
        current_bg_hex_color ? 'mirc-bg-hex' : nil,
      ].compact

      styles = [
        hex_color_style('color', current_text_hex_color),
        hex_color_style('background-color', current_bg_hex_color),
      ].compact

      if classes.empty? && styles.empty?
        text
      else
        "<span#{span_class(classes)}#{span_style(styles)}>#{text}</span>"
      end
    end

    private

    # @param [String] prefix クラスの接頭辞
    # @param [Integer] color 2桁の色コード
    # @return [String] 色設定のクラス名
    def color_class(prefix, color)
      if color == DEFAULT_COLOR_CODE
        nil
      else
        "#{prefix}%02d" % color
      end
    end

    # @param [String] key スタイルのキー
    # @param [String] hex_color 16進の色コード
    # @return [String] 16進色設定のスタイル
    def hex_color_style(key, hex_color)
      hex_color ? [key, "##{hex_color}"] : nil
    end

    # @return [String] `span` タグのクラス属性
    def span_class(classes)
      return '' if classes.empty?

      class_value = classes.join(' ')
      %Q( class="#{class_value}")
    end

    # @return [String] `span` タグのスタイル属性
    def span_style(styles)
      return '' if styles.empty?

      style_value = styles
                    .map { |key, value| "#{key}: #{value};" }
                    .join(' ')
      %Q( style="#{style_value}")
    end
  end
end
