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
    DecoratedChunk = Struct.new(:text, :attribute)

    # コンストラクタ
    # @param [String] message mIRC 形式の制御文字を含みうるメッセージ
    # @return [self]
    def initialize(message)
      # mIRC 形式の制御文字を含みうるメッセージ
      # @type [String]
      @message = message

      # 同じ属性が設定されている部分の配列
      # @type [Array<DecoratedChunk>]
      @chunks = []
    end

    # mIRC制御文字を含むメッセージを構文解析する
    # @return [self]
    def parse
      # 現在設定されている属性
      current_attr = IrcTextAttribute.new
      # 次の文字から設定される属性
      next_attr = IrcTextAttribute.new
      # 次の文字から設定される属性が更新されたか
      next_attr_touched = false

      # 現在の属性が適用される部分
      chunk = DecoratedChunk.new(+"", current_attr)

      @chunks = [chunk]

      # メッセージの文字数
      n = @message.length
      # 文字カウンタ
      i = 0
      while i < n
        c = @message[i]
        case c
        when "\x0F"
          # リセット
          next_attr_touched = true
          next_attr = IrcTextAttribute.new
        when "\x02"
          # 太字
          next_attr_touched = true
          next_attr.toggle_bold!
        when "\x1D"
          # 斜体
          next_attr_touched = true
          next_attr.toggle_italic!
        when "\x1F"
          # 下線
          next_attr_touched = true
          next_attr.toggle_underline!
        when "\x1E"
          # 打消し線
          next_attr_touched = true
          next_attr.toggle_strikethrough!
        when "\x11"
          # 等幅フォント
          next_attr_touched = true
          next_attr.toggle_monospace!
        when "\x16"
          # 色反転
          next_attr_touched = true
          next_attr.toggle_reverse!
        when "\x03"
          # 2桁表記の色設定
          next_attr_touched = true
          i += parse_color(i, next_attr)
        when "\x04"
          # 16進表記の色設定
          next_attr_touched = true
          i += parse_hex_color(i, next_attr)
        else
          if !next_attr_touched || next_attr == current_attr
            # 属性が同じならば、現在の部分に文字を追加する
            chunk.text << c
          else
            # 属性が異なれば、新しい部分を作る
            current_attr = next_attr
            next_attr = current_attr.dup

            chunk = DecoratedChunk.new(c, current_attr)
            @chunks << chunk
          end

          next_attr_touched = false
        end

        i += 1
      end

      self
    end

    # 構文解析したメッセージをHTMLとして出力する
    # @return [String] HTMLに変換されたメッセージ
    def render
      @chunks.map { |c| c.attribute.span_tag(c.text) }
             .join
    end

    private

    # 2桁色設定を解析する
    # @param [Integer] i 文字カウンタ
    # @param [IrcTextAttribute] next_attr 次に設定する属性
    # @return [Integer] 消費した文字数
    def parse_color(i, next_attr)
      color_code_part = @message[i + 1, 5]
      m = color_code_part.match(/\A(\d{1,2})(?:,(\d{1,2}))?/)

      unless m
        next_attr.reset_colors!
        return 0
      end

      text_color_str = m[1]
      bg_color_str = m[2]

      next_attr.text_color = text_color_str.to_i

      if bg_color_str
        next_attr.bg_color = bg_color_str.to_i
      end

      return m[0].length
    end

    # 16進色設定を解析する
    # @param [Integer] i 文字カウンタ
    # @param [IrcTextAttribute] next_attr 次に設定する属性
    # @return [Integer] 消費した文字数
    def parse_hex_color(i, next_attr)
      color_code_part = @message[i + 1, 13]
      m = color_code_part.match(/\A([a-fA-F\d]{6})(?:,([a-fA-F\d]{6}))?/)

      unless m
        next_attr.reset_colors!
        return 0
      end

      text_hex_color = m[1]
      bg_hex_color = m[2]

      next_attr.text_hex_color = text_hex_color

      if bg_hex_color
        next_attr.bg_hex_color = bg_hex_color
      end

      return m[0].length
    end
  end
end
