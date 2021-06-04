class Setting < ApplicationRecord
  before_save { nick_target_affiliate_message_by.downcase! }

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

  # 改行区切りテキストで保存されているため、配列に直す
  # @return [Array<String>]
  def target_amazon_affiliate_tags
    target_amazon_affiliate_tag.lines(chomp: true)
  end

  def target_amazon_affiliate_tags=(new_tags)
    target_amazon_affiliate_tag = new_tags.join("\n")
  end

  # 改行区切りテキストで保存されているため、配列に直す
  # @return [Array<String>]
  def nicks_target_affiliate_message_by
    nick_target_affiliate_message_by.lines(chomp: true)
  end
end
