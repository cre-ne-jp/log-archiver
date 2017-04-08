class Admin::Channels::LastSpeechUpdatesController < ApplicationController
  def show
    channel = Channel.friendly.find(params[:id])
    message = channel.current_last_speech

    begin
      if message
        channel_last_speech =
          channel.channel_last_speech ||
          ChannelLastSpeech.new(channel: channel)
        channel_last_speech.conversation_message = message

        channel_last_speech.save!
      end

      flash[:success] = t('views.flash.updated_last_speech')
    rescue
      flash[:danger] = t('views.flash.failed_to_update_last_speech')
    end

    redirect_to(admin_channel_path(channel))
  end
end
