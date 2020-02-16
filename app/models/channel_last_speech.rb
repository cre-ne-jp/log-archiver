# チャンネルごとの最終発言のモデル
class ChannelLastSpeech < ApplicationRecord
  belongs_to :channel
  belongs_to :conversation_message

  validates(:channel,
            presence: true,
            uniqueness: true)
  validates(:conversation_message,
            presence: true)

  # チャンネルの最終発言を更新する
  # @param [Channel] channel 更新対象のチャンネル
  # @return [self]
  def self.refresh!(channel)
    last_speech = channel.channel_last_speech || new(channel: channel)

    self.transaction do
      last_speech.conversation_message = nil

      yield if block_given?

      last_speech.conversation_message = channel.current_last_speech
      last_speech.save!
    end
  end
end
