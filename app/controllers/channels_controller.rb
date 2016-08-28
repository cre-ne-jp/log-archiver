class ChannelsController < ApplicationController
  def index
    @channels = Channel.all
  end

  def show
    @channel = Channel.find_by(identifier: params[:identifier])
    unless @channel
      raise ArgumentError, "Channel not found: #{params[:identifier]}"
    end

    @years = MessageDate.
      uniq.
      where(channel: @channel).
      pluck('YEAR(date)')
  end
end
