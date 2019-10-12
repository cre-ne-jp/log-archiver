# チャンネルごとの最終発言のモデル
class ChannelLastSpeech < ApplicationRecord
  include HashForJson

  belongs_to :channel
  belongs_to :conversation_message

  validates(:channel,
            presence: true,
            uniqueness: true)
  validates(:conversation_message,
            presence: true)
end
