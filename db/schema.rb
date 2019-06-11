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

ActiveRecord::Schema.define(version: 2018_10_10_040315) do

  create_table "channel_last_speeches", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id"
    t.integer  "conversation_message_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["channel_id"], name: "index_channel_last_speeches_on_channel_id", using: :btree
    t.index ["conversation_message_id"], name: "index_channel_last_speeches_on_conversation_message_id", using: :btree
  end

  create_table "channels", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name",            default: "",   null: false
    t.string   "identifier",      default: "",   null: false
    t.boolean  "logging_enabled", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "row_order"
    t.string "canonical_url_template", default: "", null: false
    t.index ["identifier"], name: "index_channels_on_identifier", using: :btree
    t.index ["logging_enabled"], name: "index_channels_on_logging_enabled", using: :btree
  end

  create_table "conversation_messages", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id"
    t.datetime "timestamp",                              null: false
    t.string   "nick",        limit: 64,    default: "", null: false
    t.text     "message",     limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "type"
    t.integer  "irc_user_id",               default: 0,  null: false
    t.index ["channel_id", "timestamp"], name: "index_conversation_messages_on_channel_id_and_timestamp", using: :btree
    t.index ["channel_id"], name: "index_conversation_messages_on_channel_id", using: :btree
    t.index ["id", "channel_id", "timestamp"], name: "index_conversation_messages_on_id_and_channel_id_and_timestamp", using: :btree
    t.index ["id", "channel_id"], name: "index_conversation_messages_on_id_and_channel_id", using: :btree
    t.index ["id", "timestamp"], name: "index_conversation_messages_on_id_and_timestamp", using: :btree
    t.index ["irc_user_id"], name: "index_conversation_messages_on_irc_user_id", using: :btree
    t.index ["message"], name: "index_conversation_messages_on_message", type: :fulltext
    t.index ["nick", "message"], name: "index_conversation_messages_on_nick_and_message", type: :fulltext
    t.index ["nick"], name: "index_conversation_messages_on_nick", type: :fulltext
    t.index ["timestamp"], name: "index_conversation_messages_on_timestamp", using: :btree
    t.index ["type"], name: "index_conversation_messages_on_type", using: :btree
  end

  create_table "irc_users", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "user",       limit: 64, default: "", null: false
    t.string   "host",                  default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_dates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["channel_id", "date"], name: "index_message_dates_on_channel_id_and_date", using: :btree
    t.index ["channel_id"], name: "index_message_dates_on_channel_id", using: :btree
    t.index ["date"], name: "index_message_dates_on_date", using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "channel_id"
    t.integer  "irc_user_id"
    t.string   "type"
    t.datetime "timestamp",                              null: false
    t.string   "nick",        limit: 64,    default: "", null: false
    t.text     "message",     limit: 65535
    t.string   "target",      limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["channel_id"], name: "index_messages_on_channel_id", using: :btree
    t.index ["id", "channel_id", "timestamp"], name: "index_messages_on_id_and_channel_id_and_timestamp", using: :btree
    t.index ["id", "channel_id"], name: "index_messages_on_id_and_channel_id", using: :btree
    t.index ["id", "timestamp"], name: "index_messages_on_id_and_timestamp", using: :btree
    t.index ["irc_user_id"], name: "index_messages_on_irc_user_id", using: :btree
    t.index ["nick"], name: "index_messages_on_nick", using: :btree
    t.index ["timestamp"], name: "index_messages_on_timestamp", using: :btree
    t.index ["type"], name: "index_messages_on_type", using: :btree
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "site_title",                     default: "IRC ログアーカイブ", null: false
    t.text     "text_on_homepage", limit: 65535,                         null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "username",         default: "", null: false
    t.string   "email",            default: "", null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "channel_last_speeches", "conversation_messages", name: "conversation_message_id"
end
