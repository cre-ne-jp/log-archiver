class RenameChannelColumns < ActiveRecord::Migration
  def up
    rename_column :channels, :original, :name
    rename_column :channels, :alphabet, :identifier
    rename_column :channels, :enable, :logging_enabled

    remove_column :channels, :downcase
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
