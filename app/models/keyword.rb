require 'nkf'
require 'strscan'

class Keyword < ApplicationRecord
  extend FriendlyId
  friendly_id :title

  has_many :privmsg_keyword_relationships, dependent: :destroy
  has_many :privmsgs, through: :privmsg_keyword_relationships

  validates(:title,
            presence: true)
  validates(:display_title,
            presence: true)

  # キーワードの表記を正規化する
  # @param [String] text 正規化するテキスト
  # @return [String]
  #
  # * 英数字といくつかの記号を半角にする
  # * 半角片仮名を全角にする
  # * 全角空白を半角にする
  # * 空白をアンダーバーに置換する
  # * アンダーバーの出現回数を最小化する
  def self.normalize(text)
    nkfed = NKF.nkf('-Ww -Z0 -Z1 -X -m0', text)
    spaces_replaced = nkfed.gsub(/\s/, '_')
    underbars_trimmed = spaces_replaced.
      sub(/\A_+/, '').
      sub(/_+\z/, '')

    underbars_shortened = String.new(underbars_trimmed)
    ss = StringScanner.new(underbars_shortened)

    # 以下の3通りのいずれか
    #
    # 1. 英数字以外 アンダーバー 任意の文字
    # 2. 英数字 アンダーバー 英数字以外
    # 3. 英数字 アンダーバー2個以上 英数字
    re = /([^_A-Z0-9])(_+)[^_]|([A-Z0-9])(_+)[^_A-Z0-9]|([A-Z0-9]_)(_+)[A-Z0-9]/i
    while ss.scan_until(re)
      pre_underbars_length = (ss[1] || ss[3] || ss[5]).length
      underbars_length = (ss[2] || ss[4] || ss[6]).length

      # 余分なアンダーバーを除去する
      underbars_shortened.slice!(ss.pre_match.length + pre_underbars_length,
                                 underbars_length)

      # 除去したアンダーバーの文字数も考慮しながら
      # マッチした部分の最後の文字まで戻す
      ss.pos -= (underbars_length + 1)
    end

    underbars_shortened.downcase
  end
end
