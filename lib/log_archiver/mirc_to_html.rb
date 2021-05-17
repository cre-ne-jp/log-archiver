# frozen_string_literal: true

module LogArchiver
  # mIRC 制御文字による装飾を含むメッセージを、HTML に変換する
  # @see https://www.mirc.co.uk/colors.html
  # @see https://www.mirc.com/help/html/index.html?control_codes.html
  # @see https://yoshino.tripod.com/73th/data/irccode.htm#ascii_controlcode
  # @see https://en.wikichip.org/wiki/irc/colors
  class MircToHtml
    # コンストラクタ
    # @param [String] mirc mIRC 形式の制御文字を含みうるメッセージ
    # @param [String] html_class_header HTMLタグに付加するクラスの接頭辞
    # @return [self]
    def initialize(mirc, html_class_header = 'mirc-')
      # [String] mIRC 形式の制御文字を含みうるメッセージ
      @mirc = mirc.freeze

      # [String]
      @html_class_header = html_class_header.freeze

      # [String]
      @html = ''

      # [Array<String>]
      @original = mirc.chars

      # [Array<String>]
      @converted = []

      # [Array] 一つ前の文字までに適用されている装飾
      @decorate = []

      # [Boolean]
      @decorated = false

      # [Hash<String>] 16進表記の文字色・背景色
      @hex_color = {color: nil, bg: nil}
    end

    # 変換を行なう
    # @return [String]
    def convert
      @original.size.times do |n|
        now = @original[n]

        case now
        when "\u0002"
          boolean_option('bold')
        when "\u001F"
          boolean_option('underline')
        when "\u001D"
          boolean_option('italic')
        when "\u001E"
          boolean_option('strikethrough')
        when "\u0011"
          boolean_option('monospace')
        when "\u0016"
          reverse_option
        when "\u0003"
          # color text[,background]
          if /^(\d{1,2})(?:,(\d{1,2}))?/ =~ @original[n + 1, 5].join
            color_option($1, $2)
            @original[n + 1, $&.size] = nil
          else
            color_option(99, 99)
          end
        when "\u0004"
          # hex color
          if /^([a-fA-F\d]{6})(?:,([a-fA-F\d]{6}))?/ =~ @original[n + 1, 13].join
            hex_color_option($1.upcase, $2&.upcase)
            @original[n + 1, $&.size] = nil
          else
            color_option(99, 99)
          end
        when "\u000F"
          # clear
          @decorate = []
          decorate_separator
        else
          @converted.push(now)
        end
      end

      if @decorated
        # 行末に装飾終了コードが欠けていたら補完する
        @converted.push(span_end)
      end

      @html = @converted.compact.flatten.join
    end

    private

    # 有効か無効かしか選択肢がない装飾を処理する
    # bold, underline, italic
    # @param [String]
    # @return [void]
    def boolean_option(decorating)
      if @decorate.include?(decorating)
        @decorate.delete(decorating)
      else
        @decorate.push(decorating)
      end

      decorate_separator
    end

    # 文字色・背景色を反転させる
    # @return [void]
    def reverse_option
      keywords = {
        'color' => '99',
        'bg' => '99'
      }

      keywords.keys.map do |k|
        key = @decorate.select do |d|
          d[0, k.size] == k
        end
        keywords[key.first[0, k.size]] = key.first[-2..-1] if key.any?
      end

      color_option(keywords['bg'], keywords['color'])
    end

    # 定数表記の文字色・背景色を処理する
    # 色番号 '99' はデフォルトの色(=色設定なし)
    # @param [String] text 文字色
    # @param [String] bg 背景色
    # @return [void]
    def color_option(text, bg = nil)
      keywords = {}
      keywords[:color] = 'color%02d' % (text.nil? ? 99 : text.to_i)
      keywords[:bg] = 'bg%02d' % bg.to_i if bg

      exist_keywords = keywords.map do |k, _v|
        @decorate.select do |d|
          d[0, k.size] == k.to_s
        end
      end
      exist_keywords.flatten!

      @decorate = @decorate - exist_keywords + keywords.values - %w(color99 bg99)

      @hex_color[:color] = nil if exist_keywords.include?('colorhex')
      @hex_color[:bg] = nil if exist_keywords.include?('bghex')

      decorate_separator
    end

    # 16進表記の文字色・背景色を処理する
    # @param [String] text 文字色
    # @param [String] bg 背景色
    # @return [void]
    def hex_color_option(text = nil, bg = nil)
      keywords = {}

      keywords[:color], @hex_color[:color] =
        text.nil? ? ['color99', nil] : ['colorhex', text]
      keywords[:bg], @hex_color[:bg] =
        bg.nil? ? ['bg99', nil] : ['bghex', bg]

      exist_keywords = keywords.map do |k, _v|
        @decorate.select do |d|
          d[0, k.size] == k.to_s
        end
      end
      @decorate = (@decorate - exist_keywords.flatten + keywords.values - %w(color99 bg99)).uniq

      decorate_separator
    end

    # 現在の装飾状態を確認し、必要な span タグを埋め込む
    # @return [void]
    def decorate_separator
      if @decorated
        # 一つ前の文字で何かしらの装飾がされているとき
        if @decorate.empty?
          # 今回の制御文字で全ての装飾がなくなる
          @converted.push(span_end)
        else
          # 装飾が変更される
          @converted.push("#{span_end}#{span_start}")
        end
      else
        # 一つ前の文字までは装飾がないとき
        if @decorate.empty?
          # 設定すべき装飾がない
        else
          @converted.push(span_start)
        end
      end
    end

    # span の開始タグを返す
    # @return [String]
    def span_start
      @decorated = true

      class_name_with_header = @decorate.map do |d|
        "#{@html_class_header}#{d}"
      end

      hex_color_styles = []
      unless @hex_color[:color].nil?
        hex_color_styles.push("color: ##{@hex_color[:color]};")
      end
      unless @hex_color[:bg].nil?
        hex_color_styles.push("background-color: ##{@hex_color[:bg]};")
      end

      %Q(<span class="#{class_name_with_header.join(' ')}"%s>) % (
        hex_color_styles.empty? ? '' : %Q( style="#{hex_color_styles.join(' ')}")
      )
    end

    # span の終了タグを返す
    # @return [String]
    def span_end
      @decorated = false
      '</span>'
    end
  end
end
