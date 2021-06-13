class AddColumnAmazonAffiliateTagToSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :amazon_affiliate_tag, :string
    add_column :settings, :target_amazon_affiliate_tag, :text
    add_column :settings, :nick_target_affiliate_message_by, :text
  end
end
