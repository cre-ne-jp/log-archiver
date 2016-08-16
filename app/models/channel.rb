class Channel < ActiveRecord::Base
  has_many :messages
  has_many :joins
  has_many :parts
  has_many :quits
  has_many :kicks
  has_many :nicks
  has_many :topics
  has_many :privmsgs
  has_many :notices
  has_many :message_dates

  validates(:name, presence: true)
  validates(:identifier,
            presence: true,
            uniqueness: true)

  # ログ記録が有効なチャンネル
  scope :logging_enabled, -> { where(logging_enabled: true) }
  # ログ記録が無効なチャンネル
  scope :logging_disabled, -> { where(logging_enabled: false) }

  # 接頭辞付きのチャンネル名を返す
  # @return [String]
  def name_with_prefix
    "##{name}"
  end

  # 小文字の接頭辞付きチャンネル名を返す
  # @return [String]
  def lowercase_name_with_prefix
    name_with_prefix.downcase
  end
end
