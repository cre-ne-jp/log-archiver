# frozen_string_literal: true

module MessagesDigest
  extend ActiveSupport::Concern

  # フラグメント識別子に使うハッシュ関数名
  DIGEST_HASH_FUNCTION = 'fnv1a32'.freeze
  # フラグメント識別子のハッシュを 16 進数表現にしたときの文字数
  DIGEST_HASH_LENGTH = 8
  # フラグメント識別子の正規表現
  DIGEST_REGEXP = /\A#{DIGEST_HASH_FUNCTION}:([\da-f]{#{DIGEST_HASH_LENGTH}})\z/o.freeze

  # フラグメント識別子を得る
  # @return [String]
  def digest_hash
#    digest.sub("#{DIGEST_HASH_FUNCTION}:", '')
    digest.match(DIGEST_REGEXP)[1]
  end

  # フラグメント識別子をオブジェクトに作成・追加する
  def add_digest
    unless digest.match?(DIGEST_REGEXP)
      cfnv = CFnv.new
      original_string = "#{timestamp.to_i}#{type}#{nick}#{message}"
      hash_integer = cfnv.send(DIGEST_HASH_FUNCTION, original_string)
      digest_string = sprintf("%0#{DIGEST_HASH_LENGTH}x", hash_integer)
      self.digest = "#{DIGEST_HASH_FUNCTION}:#{digest_string}"

      self.save! if self.changed?
    end

    self
  end
end
