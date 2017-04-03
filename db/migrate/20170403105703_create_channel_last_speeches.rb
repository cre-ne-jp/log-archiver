# チャンネルごとの最終発言
class CreateChannelLastSpeeches < ActiveRecord::Migration
  def change
    create_table :channel_last_speeches, options: 'ENGINE=Mroonga' do |t|
      # チャンネル
      t.references :channel, index: true, foreign_key: true
      # 発言
      t.references :conversation_message, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
