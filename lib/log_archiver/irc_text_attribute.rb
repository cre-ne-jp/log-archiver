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
    attr_accessor :text_color
    # @return [String] 背景色
    attr_accessor :bg_color
    # @return [String] 16進表記の文字色
    attr_accessor :text_hex_color
    # @return [String] 16進表記の背景色
    attr_accessor :bg_hex_color

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

      self
    end

    # 16進指定の文字色および背景色をリセットする
    # @return [self]
    def reset_hex_colors!
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

    # `span` 開始タグに変換する
    #
    # 既定の属性だった場合は空文字列を返す。
    # 変更点があった場合は、それがクラスや `style` 属性に設定された
    # `span` 開始タグを返す。
    #
    # @return [String] `span` 開始タグ
    def span_start_tag
      classes = [
        @bold ? 'mirc-bold' : nil,
        @italic ? 'mirc-italic' : nil,
        @underline ? 'mirc-underline' : nil,
        @strikethrough ? 'mirc-strikethrough' : nil,
        @monospace ? 'mirc-monospace' : nil,
        color_class('mirc-color', current_text_color, current_text_hex_color),
        color_class('mirc-bg', current_bg_color, current_bg_hex_color),
      ].compact

      styles = [
        hex_color_style('color', current_text_hex_color),
        hex_color_style('background-color', current_bg_hex_color),
      ].compact

      if classes.empty? && styles.empty?
        ''
      else
        "<span#{span_class(classes)}#{span_style(styles)}>"
      end
    end

    private

    # @param [String] prefix クラスの接頭辞
    # @param [Integer] color 2桁の色コード
    # @param [String] hex_color 16進の色コード
    # @return [String] 色設定のクラス名
    def color_class(prefix, color, hex_color)
      if hex_color || color == DEFAULT_COLOR_CODE
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
