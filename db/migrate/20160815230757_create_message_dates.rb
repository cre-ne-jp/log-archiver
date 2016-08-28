class CreateMessageDates < ActiveRecord::Migration
  def change
    create_table :message_dates do |t|
      t.references :channel, index: true, foreign_key: true
      t.date :date

      t.timestamps null: false
    end
    add_index :message_dates, :date
    add_index :message_dates, [:channel_id, :date]
  end
end
