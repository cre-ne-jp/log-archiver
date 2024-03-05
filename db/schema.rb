# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_16_072343) do
  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "archive_reasons", charset: "utf8mb4", force: :cascade do |t|
    t.string "reason", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "archived_conversation_messages", charset: "utf8mb4", options: "ENGINE=Mroonga", force: :cascade do |t|
    t.integer "old_id", default: 0, null: false
    t.integer "channel_id"
    t.datetime "timestamp", null: false
    t.string "nick", limit: 64, default: "", null: false
    t.text "message"
    t.string "type", null: false
    t.integer "irc_user_id", default: 1, null: false
    t.string "digest", default: "", null: false
    t.integer "archive_reason_id", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "channel_last_speeches", id: :integer, charset: "utf8mb4", options: "ENGINE=Mroonga", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "conversation_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_channel_last_speeches_on_channel_id"
    t.index ["conversation_message_id"], name: "index_channel_last_speeches_on_conversation_message_id"
  end

  create_table "channels", id: :integer, charset: "utf8mb4", options: "ENGINE=Mroonga", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "identifier", default: "", null: false
    t.boolean "logging_enabled", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "row_order"
    t.string "canonical_url_template", default: ""
    t.index ["identifier"], name: "index_channels_on_identifier"
    t.index ["logging_enabled"], name: "index_channels_on_logging_enabled"
  end

  create_table "conversation_messages", id: :integer, charset: "utf8mb4", options: "ENGINE=Mroonga", force: :cascade do |t|
    t.integer "channel_id"
    t.datetime "timestamp", null: false
    t.string "nick", limit: 64, default: "", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "irc_user_id", default: 1, null: false
    t.string "digest", default: "", null: false
    t.index ["channel_id", "timestamp", "id"], name: "index_conversation_messages_on_channel_id_and_timestamp_and_id"
    t.index ["message", "nick"], name: "index_conversation_messages_on_message_and_nick", type: :fulltext
    t.index ["message"], name: "index_conversation_messages_on_message", type: :fulltext
    t.index ["nick"], name: "index_conversation_messages_on_nick", type: :fulltext
    t.index ["timestamp", "channel_id"], name: "index_conversation_messages_on_timestamp_and_channel_id"
    t.index ["type", "channel_id", "timestamp"], name: "index_cm_on_type_and_channel_id_and_timestamp"
  end

  create_table "irc_users", id: :integer, charset: "utf8mb4", options: "ENGINE=Mroonga", force: :cascade do |t|
    t.string "user", limit: 64, default: "", null: false
    t.string "host", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", charset: "utf8mb4", options: "ENGINE=Mroonga", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.string "display_title", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["display_title"], name: "index_keywords_on_display_title", type: :fulltext
    t.index ["title"], name: "index_keywords_on_title", unique: true
  end

  create_table "message_dates", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "channel_id"
    t.date "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["channel_id", "date"], name: "index_message_dates_on_channel_id_and_date"
    t.index ["channel_id"], name: "index_message_dates_on_channel_id"
    t.index ["date"], name: "index_message_dates_on_date"
  end

  create_table "messages", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "irc_user_id", default: 1, null: false
    t.string "type"
    t.datetime "timestamp", null: false
    t.string "nick", limit: 64, default: "", null: false
    t.text "message"
    t.string "target", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "digest", default: "", null: false
    t.index ["timestamp", "channel_id"], name: "index_messages_on_timestamp_and_channel_id"
  end

  create_table "privmsg_keyword_relationships", charset: "utf8mb4", force: :cascade do |t|
    t.integer "privmsg_id"
    t.integer "keyword_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["keyword_id"], name: "index_privmsg_keyword_relationships_on_keyword_id"
    t.index ["privmsg_id", "keyword_id"], name: "index_rel_on_privmsg_id_and_keyword_id", unique: true
    t.index ["privmsg_id"], name: "index_privmsg_keyword_relationships_on_privmsg_id"
  end

  create_table "settings", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "site_title", default: "IRC ログアーカイブ", null: false
    t.text "text_on_homepage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
