class AddTimestampColumns < ActiveRecord::Migration
  def change
    target_tables = %i(channels irc_users message_dates messages)
    target_tables.each do |table_name|
      add_column table_name, :created_at, :datetime
      add_column table_name, :updated_at, :datetime
    end
  end
end
