class RecreateMessagesAndMessageDates < ActiveRecord::Migration[4.2]
  def change
    create_table "message_dates" do |t|
      t.references  "channel"
      t.date     "date"
    end

    add_index "message_dates", ["channel_id", "date"]
    add_index "message_dates", ["channel_id"]
    add_index "message_dates", ["date"]

    create_table "messages" do |t|
      t.references  "channel"
      t.references  "irc_user"
      t.string   "type",        limit: 255
      t.datetime "timestamp",                              null: false
      t.string   "nick",        limit: 64,    default: "", null: false
      t.text     "message",     limit: 65535
      t.string   "target",      limit: 64
    end

    add_index "messages", ["channel_id"]
    add_index "messages", ["id", "channel_id", "timestamp"]
    add_index "messages", ["id", "channel_id"]
    add_index "messages", ["id", "timestamp"]
    add_index "messages", ["irc_user_id"]
    add_index "messages", ["nick"]
    add_index "messages", ["timestamp"]
    add_index "messages", ["type"]
  end
end
