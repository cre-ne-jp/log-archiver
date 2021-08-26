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
  # @return [ChannelLastSpeech, nil] 更新後の最終発言データ
  def self.refresh!(channel)
    current_last_speech = channel.current_last_speech
    unless current_last_speech
      where(channel: channel)
        .delete_all

      return nil
    end

    find_or_initialize_by(channel: channel).tap do |s|
      s.conversation_message = current_last_speech
      s.save!
    end
  end
end
