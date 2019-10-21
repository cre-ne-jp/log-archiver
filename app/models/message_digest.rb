# frozen_string_literal: true

# メッセージを要約するハッシュ値の計算処理のモジュール
module MessageDigest
  # CFnvインスタンスを毎回作る必要がないため、ここに作っておく
  CFNV = CFnv.new
  # ハッシュ値を文字列で表すときの書式
  #
  # 0で埋めた16進数8文字
  DIGEST_FORMAT = '%08x'.freeze

  # ハッシュ値の文字列を返す
  # @return [String]
  #
  # タイムスタンプ、メッセージの種類、ニックネーム、メッセージの内容から
  # 作った、32ビットのFNV-1aアルゴリズムによるハッシュ値。
  def digest
    hash_src = "#{timestamp.to_i} #{type} #{nick} #{message}"
    hash = CFNV.fnv1a32(hash_src)

    DIGEST_FORMAT % hash
  end
end
