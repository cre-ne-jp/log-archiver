class Admin::Channels::LastSpeechUpdatesController < ApplicationController
  def show
    channel = Channel.friendly.find(params[:id])

    begin
      ChannelLastSpeech.refresh!(channel)

      flash[:success] = t('views.flash.updated_last_speech')
    rescue
      flash[:danger] = t('views.flash.failed_to_update_last_speech')
    end

    redirect_to(admin_channel_path(channel))
  end
end
