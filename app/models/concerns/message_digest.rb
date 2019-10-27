# frozen_string_literal: true

module MessageDigest
  extend ActiveSupport::Concern

  # ハッシュ値を 16 進数表現にしたときの文字数
  DIGEST_LENGTH = 8
  # ハッシュ値の文字列表現の書式
  DIGEST_FORMAT = "fnv1a32:%0#{DIGEST_LENGTH}x".freeze
  # CFnv インスタンス
  CFNV = CFnv.new

  # ハッシュ値本体を得る
  # @return [String]
  def digest_value
    digest.sub('fnv1a32:', '')
  end

  # メッセージの内容からハッシュ値の文字列表現を生成する
  # @return [String]
  def generate_digest
    original_string = "#{timestamp.to_i} #{type} #{channel.identifier} #{nick} #{message}"
    hash_integer = CFNV.fnv1a32(original_string)

    sprintf(DIGEST_FORMAT, hash_integer)
  end

  # ハッシュ値を更新する
  # @return [self]
  def refresh_digest!
    self.digest = generate_digest
    self
  end
end
