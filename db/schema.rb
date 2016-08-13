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

ActiveRecord::Schema.define(version: 20160813063427) do

  create_table "channels", force: :cascade do |t|
    t.string   "name",            limit: 255, default: "irc_test", null: false
    t.string   "identifier",      limit: 255, default: "irc_test", null: false
    t.boolean  "logging_enabled",             default: true,       null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "irc_users", force: :cascade do |t|
    t.string   "name",       limit: 9,   default: "", null: false
    t.string   "host",       limit: 255, default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

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
  add_index "messages", ["irc_user_id"], name: "index_messages_on_irc_user_id", using: :btree
  add_index "messages", ["nick"], name: "index_messages_on_nick", using: :btree
  add_index "messages", ["timestamp"], name: "index_messages_on_timestamp", using: :btree
  add_index "messages", ["type"], name: "index_messages_on_type", using: :btree

  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "irc_users"
end
