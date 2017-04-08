# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170408163604) do

  create_table "channel_last_speeches", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id",              limit: 4
    t.integer  "conversation_message_id", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "channel_last_speeches", ["channel_id"], name: "index_channel_last_speeches_on_channel_id", using: :btree
  add_index "channel_last_speeches", ["conversation_message_id"], name: "index_channel_last_speeches_on_conversation_message_id", using: :btree

  create_table "channels", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name",            limit: 255, default: "",   null: false
    t.string   "identifier",      limit: 255, default: "",   null: false
    t.boolean  "logging_enabled",             default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "row_order",       limit: 4
  end

  add_index "channels", ["identifier"], name: "index_channels_on_identifier", using: :btree
  add_index "channels", ["logging_enabled"], name: "index_channels_on_logging_enabled", using: :btree

  create_table "conversation_messages", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id",  limit: 4
    t.integer  "irc_user_id", limit: 4
    t.datetime "timestamp",                              null: false
    t.string   "nick",        limit: 64,    default: "", null: false
    t.text     "message",     limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "type",        limit: 255
  end

  add_index "conversation_messages", ["channel_id", "timestamp"], name: "index_conversation_messages_on_channel_id_and_timestamp", using: :btree
  add_index "conversation_messages", ["channel_id"], name: "index_conversation_messages_on_channel_id", using: :btree
  add_index "conversation_messages", ["id", "channel_id", "timestamp"], name: "index_conversation_messages_on_id_and_channel_id_and_timestamp", using: :btree
  add_index "conversation_messages", ["id", "channel_id"], name: "index_conversation_messages_on_id_and_channel_id", using: :btree
  add_index "conversation_messages", ["id", "timestamp"], name: "index_conversation_messages_on_id_and_timestamp", using: :btree
  add_index "conversation_messages", ["irc_user_id"], name: "index_conversation_messages_on_irc_user_id", using: :btree
  add_index "conversation_messages", ["message"], name: "index_conversation_messages_on_message", type: :fulltext
  add_index "conversation_messages", ["nick", "message"], name: "index_conversation_messages_on_nick_and_message", type: :fulltext
  add_index "conversation_messages", ["nick"], name: "index_conversation_messages_on_nick", type: :fulltext
  add_index "conversation_messages", ["timestamp"], name: "index_conversation_messages_on_timestamp", using: :btree
  add_index "conversation_messages", ["type"], name: "index_conversation_messages_on_type", using: :btree

  create_table "irc_users", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "user",       limit: 64,  default: "", null: false
    t.string   "host",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_dates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id", limit: 4
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_dates", ["channel_id", "date"], name: "index_message_dates_on_channel_id_and_date", using: :btree
  add_index "message_dates", ["channel_id"], name: "index_message_dates_on_channel_id", using: :btree
  add_index "message_dates", ["date"], name: "index_message_dates_on_date", using: :btree

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id",  limit: 4
    t.integer  "irc_user_id", limit: 4
    t.string   "type",        limit: 255
    t.datetime "timestamp",                              null: false
    t.string   "nick",        limit: 64,    default: "", null: false
    t.text     "message",     limit: 65535
    t.string   "target",      limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["channel_id"], name: "index_messages_on_channel_id", using: :btree
  add_index "messages", ["id", "channel_id", "timestamp"], name: "index_messages_on_id_and_channel_id_and_timestamp", using: :btree
  add_index "messages", ["id", "channel_id"], name: "index_messages_on_id_and_channel_id", using: :btree
  add_index "messages", ["id", "timestamp"], name: "index_messages_on_id_and_timestamp", using: :btree
  add_index "messages", ["irc_user_id"], name: "index_messages_on_irc_user_id", using: :btree
  add_index "messages", ["nick"], name: "index_messages_on_nick", using: :btree
  add_index "messages", ["timestamp"], name: "index_messages_on_timestamp", using: :btree
  add_index "messages", ["type"], name: "index_messages_on_type", using: :btree

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "site_title",       limit: 255,   default: "IRC ログアーカイブ", null: false
    t.text     "text_on_homepage", limit: 65535,                         null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "username",         limit: 255, default: "", null: false
    t.string   "email",            limit: 255, default: "", null: false
    t.string   "crypted_password", limit: 255
    t.string   "salt",             limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "channel_last_speeches", "conversation_messages", name: "conversation_message_id"
end
