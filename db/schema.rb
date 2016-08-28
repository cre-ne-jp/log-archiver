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

ActiveRecord::Schema.define(version: 20160819011055) do

  create_table "channels", force: :cascade do |t|
    t.string   "name",            limit: 255, default: "",   null: false
    t.string   "identifier",      limit: 255, default: "",   null: false
    t.boolean  "logging_enabled",             default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "channels", ["identifier"], name: "index_channels_on_identifier", unique: true, using: :btree
  add_index "channels", ["logging_enabled"], name: "index_channels_on_logging_enabled", using: :btree

  create_table "irc_users", force: :cascade do |t|
    t.string   "user",       limit: 64,  default: "", null: false
    t.string   "host",       limit: 255, default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "message_dates", force: :cascade do |t|
    t.integer  "channel_id", limit: 4
    t.date     "date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "message_dates", ["channel_id", "date"], name: "index_message_dates_on_channel_id_and_date", using: :btree
  add_index "message_dates", ["channel_id"], name: "index_message_dates_on_channel_id", using: :btree
  add_index "message_dates", ["date"], name: "index_message_dates_on_date", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "channel_id",  limit: 4
    t.integer  "irc_user_id", limit: 4
    t.string   "type",        limit: 255
    t.datetime "timestamp",                              null: false
    t.string   "nick",        limit: 64,    default: "", null: false
    t.text     "message",     limit: 65535
    t.string   "target",      limit: 64
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "messages", ["channel_id"], name: "index_messages_on_channel_id", using: :btree
  add_index "messages", ["id", "channel_id", "timestamp"], name: "index_messages_on_id_and_channel_id_and_timestamp", using: :btree
  add_index "messages", ["id", "channel_id"], name: "index_messages_on_id_and_channel_id", using: :btree
  add_index "messages", ["id", "timestamp"], name: "index_messages_on_id_and_timestamp", using: :btree
  add_index "messages", ["irc_user_id"], name: "index_messages_on_irc_user_id", using: :btree
  add_index "messages", ["nick"], name: "index_messages_on_nick", using: :btree
  add_index "messages", ["timestamp"], name: "index_messages_on_timestamp", using: :btree
  add_index "messages", ["type"], name: "index_messages_on_type", using: :btree

  add_foreign_key "message_dates", "channels"
  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "irc_users"
end
