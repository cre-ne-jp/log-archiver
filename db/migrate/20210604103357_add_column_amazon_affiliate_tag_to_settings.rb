class AddColumnAmazonAffiliateTagToSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :amazon_affiliate_tag, :string
  end
end
