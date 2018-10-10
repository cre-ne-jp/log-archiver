class AddCanonicalsitesToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :canonical_site, :string, default: ''
  end
end
