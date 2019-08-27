class IrcUser < ApplicationRecord
  include HashForJson

  has_many :messages

  validates :user,
    presence: true,
    length: { maximum: 64 }
  validates :host, presence: true

  # ニックネーム・ユーザー名・ホストを含むマスクを返す
  # @param [String] nick ニックネーム
  # @return [String]
  def mask(nick)
    "#{nick}!#{user}@#{host}"
  end

  # ユーザー名とホストを含む文字列を返す
  # @return [String]
  def user_host
    "#{user}@#{host}"
  end
end
