class Channel < ActiveRecord::Base
  validates(:name, presence: true)
  validates(:identifier, presence: true)
  validates(:logging_enabled, presence: true)

  # 接頭辞付きのチャンネル名を返す
  # @return [String]
  def name_with_prefix
    "##{name}"
  end
end
