class IrcUser < ActiveRecord::Base
  has_many :messages

  validates :name,
    presence: true,
    length: { maximum: 64 }
  validates :host, presence: true

  # ニックネーム・ユーザー名・ホストを含むマスクを返す
  # @param [String] nick ニックネーム
  # @return [String]
  def mask(nick)
    "#{nick}!#{name}@#{host}"
  end
end
