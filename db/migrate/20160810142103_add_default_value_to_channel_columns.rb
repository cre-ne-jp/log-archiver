class AddDefaultValueToChannelColumns < ActiveRecord::Migration
  def change
    change_column_default :channels, :name, 'irc_test'
    change_column_default :channels, :identifier, 'irc_test'
  end
end
