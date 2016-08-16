class Channel < ActiveRecord::Base
  validates(:name, presence: true)
  validates(:identifier, presence: true)

  # ログ記録が有効なチャンネル
  scope :logging_enabled, -> { where(logging_enabled: true) }
  # ログ記録が無効なチャンネル
  scope :logging_disabled, -> { where(logging_enabled: false) }

  # ログ記録が有効なチャンネル名の配列を返す
  # @param [Boolean] lowercase 小文字に変換するかどうか
  # @return [Array<String>]
  def self.logging_enabled_names_with_prefix(lowercase: false)
    names = logging_enabled.pluck(:name)
    modifier =
      if lowercase
        ->(channel_name) { "##{channel_name.downcase}" }
      else
        ->(channel_name) { "##{channel_name}" }
      end

    names.map(&modifier)
  end

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
