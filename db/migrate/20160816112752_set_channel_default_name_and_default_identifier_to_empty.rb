class SetChannelDefaultNameAndDefaultIdentifierToEmpty < ActiveRecord::Migration[4.2]
  def change
    change_column_default :channels, :identifier, ''
    change_column_default :channels, :name, ''
  end
end
