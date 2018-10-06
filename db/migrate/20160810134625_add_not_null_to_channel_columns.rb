class AddNotNullToChannelColumns < ActiveRecord::Migration[4.2]
  def change
    change_column_null :channels, :name, false
    change_column_null :channels, :identifier, false
    change_column_null :channels, :logging_enabled, false

    change_column_default :channels, :logging_enabled, true
  end
end
