class Channel < ActiveRecord::Base
  has_many :messages

  validates(:name, presence: true)
  validates(:identifier, presence: true)

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
