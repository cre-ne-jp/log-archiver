# frozen_string_literal: true

module MessagesFragment
  extend ActiveSupport::Concern

  # フラグメント識別子に使うハッシュ関数名
  FRAGMENT_HASH_FUNCTION = 'fnv1a32'.freeze
  # フラグメント識別子のハッシュを 16 進数表現にしたときの文字数
  FRAGMENT_HASH_LENGTH = 8
  # フラグメント識別子の正規表現
  FRAGMENT_REGEXP = /\A#{FRAGMENT_HASH_FUNCTION}:([\da-f]{#{FRAGMENT_HASH_LENGTH}})\z/o.freeze

  # フラグメント識別子を得る
  # @return [String]
  def fragment_hash
#    fragment.sub("#{FRAGMENT_HASH_FUNCTION}:", '')
    fragment.match(FRAGMENT_REGEXP)[1]
  end

  # フラグメント識別子をオブジェクトに作成・追加する
  def add_fragment
    unless fragment.match?(FRAGMENT_REGEXP)
      cfnv = CFnv.new
      original_string = "#{timestamp}#{type}#{nick}#{message}"
      hash_integer = cfnv.send(FRAGMENT_HASH_FUNCTION, original_string)
      fragment_string = sprintf('%08x', hash_integer)
      self.fragment = "#{FRAGMENT_HASH_FUNCTION}:#{fragment_string}"
    end

    self
  end
end
