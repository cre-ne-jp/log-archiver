# frozen_string_literal: true

module LogArchiver
  module MircColorTestData
    Decoration = Struct.new(
      :text_color,
      :bg_color,
      :text_hex_color,
      :bg_hex_color,
      keyword_init: true
    ) do
      def self.from_match_data(m)
        new(
          text_color: m[:text_color].gsub('*', ''),
          bg_color: m[:bg_color].gsub('*', ''),
          text_hex_color: m[:text_hex_color].gsub('*', ''),
          bg_hex_color: m[:bg_hex_color].gsub('*', '')
        )
      end
    end

    TestData = Struct.new(
      :name,
      :message,
      :expected,
      keyword_init: true
    )

    module_function

    def load_test_data_set
      test_data_set = []

      section = ''
      subsection = ''
      initial = nil
      initial_span = ''

      initial_command = ''
      initial_message = ''

      File.open(File.join(__dir__, 'mirc_color_test_data.md')) do |f|
        while line = f.gets
          case line
          when /\A(#+) (.+)/
            m = Regexp.last_match
            section_level = m[1].length
            content = m[2]

            case section_level
            when 1
              section = content
            when 2
              subsection = content
            end
          when /\A初期設定コマンド：(?:`([^`]+)`)?/
            m = Regexp.last_match
            initial_command = binding.eval(%Q|"#{m[1]}"|)
            initial_message = "#{initial_command}初期状態"
          when /\A\|（初期状態）\|(?<text_color>[^|]+)\|(?<bg_color>[^|]+)\|(?<text_hex_color>[^|]+)\|(?<bg_hex_color>[^|]+)/
            m = Regexp.last_match

            initial = Decoration.from_match_data(m)
            initial_span = span('初期状態', initial)
          when /\A\|`(?<command_expr>[^`]+)`\|(?<text_color>[^|]+)\|(?<bg_color>[^|]+)\|(?<text_hex_color>[^|]+)\|(?<bg_hex_color>[^|]+)\|(?<behavior>[^|]+)\|Y\|/
            m = Regexp.last_match

            name = "#{section}: #{subsection}: #{m[:behavior]}"

            command = binding.eval(%Q|"#{m[:command_expr]}"|)
            message = "#{initial_message}#{command}設定後"

            decoration = Decoration.from_match_data(m)
            decorated_span = span('設定後', decoration)

            expected = "#{initial_span}#{decorated_span}"

            test_data_set << TestData.new(
              name: name,
              message: message,
              expected: expected
            )
          end
        end
      end

      test_data_set
    end

    def span(content, decoration)
      classes = []
      styles = []

      unless decoration.text_color == '99'
        classes << "mirc-color#{decoration.text_color}"
      end

      unless decoration.text_hex_color == 'nil'
        classes << "mirc-color-hex"
        styles << "color: #{decoration.text_hex_color};"
      end

      unless decoration.bg_color == '99'
        classes << "mirc-bg#{decoration.bg_color}"
      end

      unless decoration.bg_hex_color == 'nil'
        classes << "mirc-bg-hex"
        styles << "background-color: #{decoration.bg_hex_color};"
      end

      if classes.empty? && styles.empty?
        return content
      end

      start_tag = +'<span'

      unless classes.empty?
        start_tag << %Q( class="#{classes.join(' ')}")
      end

      unless styles.empty?
        start_tag << %Q( style="#{styles.join(' ')}")
      end

      start_tag << '>'

      "#{start_tag}#{content}</span>"
    end
  end
end
