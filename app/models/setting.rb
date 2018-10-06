class Setting < ApplicationRecord
  validates(
    :site_title,
    presence: true,
    length: { maximum: 255 }
  )

  # アプリケーションの設定を取得する
  # @return [Setting]
  def self.get
    first!
  end
end
