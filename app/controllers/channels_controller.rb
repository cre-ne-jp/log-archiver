class ChannelsController < ApplicationController
  def index
    @channels = Channel.for_channels_index
  end

  def show
    @channel = Channel.friendly.find(params[:id])
    unless @channel
      raise ArgumentError, "Channel not found: #{params[:identifier]}"
    end

    @years = MessageDate.
      uniq.
      where(channel: @channel).
      pluck('YEAR(date)')
  end

  private

  def last_speech_timestamp(channel)
    channel.last_speech&.timestamp || DateTime.new
  end
end
