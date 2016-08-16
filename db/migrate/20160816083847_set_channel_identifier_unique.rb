class SetChannelIdentifierUnique < ActiveRecord::Migration
  def change
    add_index :channels, :identifier, unique: true
    add_index :channels, :logging_enabled
  end
end
