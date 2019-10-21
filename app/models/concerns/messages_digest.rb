# frozen_string_literal: true

module MessagesDigest
  extend ActiveSupport::Concern

  # フラグメント識別子のハッシュを 16 進数表現にしたときの文字数
  DIGEST_HASH_LENGTH = 8
  # フラグメント識別子の正規表現
  DIGEST_REGEXP = /\A[\da-f]{#{DIGEST_HASH_LENGTH}}\z/o.freeze
  # CFnv インスタンス
  CFNV = CFnv.new

  # フラグメント識別子をオブジェクトに作成・追加する
  def add_digest
    unless digest.match?(DIGEST_REGEXP)
      original_string = "#{timestamp.to_i}#{type}#{nick}#{message}"
      hash_integer = CFNV.fnv1a32(original_string)
      self.digest = sprintf("%0#{DIGEST_HASH_LENGTH}x", hash_integer)

      self.save! if self.changed?
    end

    self
  end
end
