class RecreateChannels < ActiveRecord::Migration
  def change
    drop_table :messages
    drop_table :message_dates

    drop_table :channels

    create_table "channels", options: 'ENGINE=Mroonga' do |t|
      t.string   "name",            default: "",   null: false
      t.string   "identifier",      default: "",   null: false
      t.boolean  "logging_enabled", default: true, null: false
    end

    add_index "channels", ["identifier"]
    add_index "channels", ["logging_enabled"]
  end
end
