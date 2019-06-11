class AddCanonicalsitesToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :canonical_url_template, :string, default: ''
  end
end
