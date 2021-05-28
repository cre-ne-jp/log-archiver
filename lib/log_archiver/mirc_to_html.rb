# frozen_string_literal: true

module LogArchiver
  # mIRC 制御文字による装飾を含むメッセージを、HTML に変換する
  # @see https://www.mirc.co.uk/colors.html
  # @see https://www.mirc.com/help/html/index.html?control_codes.html
  # @see https://yoshino.tripod.com/73th/data/irccode.htm#ascii_controlcode
  # @see https://en.wikichip.org/wiki/irc/colors
  class MircToHtml
    # 装飾された部分を表す構造体
    # @!attribute text
    #   @return [String] その部分に含まれる文章
    # @!attribute attribute
    #   @return [IrcTextAttribute] 設定されている属性
    DecoratedChunk = Struct.new(:text, :attribute) do
      # 装飾が設定された `span` タグで内容を包む
      # @return [String]
      def wrap_with_span_tag
        span_start_tag = self.attribute.span_start_tag
        span_start_tag.empty? ? self.text : "#{span_start_tag}#{self.text}</span>"
      end
    end

    # コンストラクタ
    # @param [String] mirc mIRC 形式の制御文字を含みうるメッセージ
    # @return [self]
    def initialize(mirc)
      # mIRC 形式の制御文字を含みうるメッセージ
      # @type [String]
      @mirc = mirc.freeze

      # @type [Array<DecoratedChunk>]
      @chunks = []
    end

    # mIRC制御文字を含むメッセージを構文解析する
    # @return [self]
    def parse
      current_attr = IrcTextAttribute.new
      next_attr = IrcTextAttribute.new
      next_attr_touched = false

      chunk = DecoratedChunk.new(+"", current_attr)
      @chunks = [chunk]

      it = @mirc.each_char.with_index
      loop do
        ch, i = it.next

        case ch
        when "\x0F"
          next_attr_touched = true
          next_attr = IrcTextAttribute.new
        when "\x02"
          next_attr_touched = true
          next_attr.toggle_bold!
        when "\x1D"
          next_attr_touched = true
          next_attr.toggle_italic!
        when "\x1F"
          next_attr_touched = true
          next_attr.toggle_underline!
        when "\x1E"
          next_attr_touched = true
          next_attr.toggle_strikethrough!
        when "\x11"
          next_attr_touched = true
          next_attr.toggle_monospace!
        when "\x16"
          next_attr_touched = true
          next_attr.toggle_reverse!
        when "\x03"
          next_attr_touched = true
          parse_color(i, it, next_attr)
        when "\x04"
          next_attr_touched = true
          parse_hex_color(i, it, next_attr)
        else
          if !next_attr_touched || next_attr == current_attr
            # 属性が同じならば、現在の部分に文字を追加する
            chunk.text << ch
          else
            # 属性が異なれば、新しい部分を作る
            current_attr = next_attr
            next_attr = current_attr.dup

            chunk = DecoratedChunk.new(ch, current_attr)
            @chunks << chunk
          end

          next_attr_touched = false
        end
      end

      self
    end

    # 構文解析したメッセージをHTMLとして出力する
    # @return [String] HTMLに変換されたメッセージ
    def render
      @chunks.map(&:wrap_with_span_tag).join
    end

    private

    # 2桁色設定を解析する
    # @param [Integer] i 文字カウンタ
    # @param [Enumerator] it 解析対象文字列の外部イテレータ
    # @param [IrcTextAttribute] next_attr 次に設定する属性
    # @return [void]
    def parse_color(i, it, next_attr)
      color_code_part = @mirc[i + 1, 5]
      m = color_code_part.match(/\A(\d{1,2})(?:,(\d{1,2}))?/)

      unless m
        next_attr.reset_colors!
        return
      end

      text_color_str = m[1]
      bg_color_str = m[2]

      next_attr.text_color = text_color_str.to_i

      if bg_color_str
        next_attr.bg_color = bg_color_str.to_i
      end

      m[0].length.times do
        it.next
      end
    end

    # 16進色設定を解析する
    # @param [Integer] i 文字カウンタ
    # @param [Enumerator] it 解析対象文字列の外部イテレータ
    # @param [IrcTextAttribute] next_attr 次に設定する属性
    # @return [void]
    def parse_hex_color(i, it, next_attr)
      color_code_part = @mirc[i + 1, 13]
      m = color_code_part.match(/\A([a-fA-F\d]{6})(?:,([a-fA-F\d]{6}))?/)

      unless m
        next_attr.reset_hex_colors!
        return
      end

      text_hex_color = m[1]
      bg_hex_color = m[2]

      next_attr.text_hex_color = text_hex_color

      if bg_hex_color
        next_attr.bg_hex_color = bg_hex_color
      end

      m[0].length.times do
        it.next
      end
    end
  end
end
