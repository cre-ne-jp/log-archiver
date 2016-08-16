class SetChannelDefaultNameAndDefaultIdentifierToEmpty < ActiveRecord::Migration
  def change
    change_column_default :channels, :identifier, ''
    change_column_default :channels, :name, ''
  end
end
