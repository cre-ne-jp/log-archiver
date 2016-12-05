class WelcomeController < ApplicationController
  def index
    @channels = Channel.select(:id, :identifier, :name)
    @channel_data_for_select = [['全チャンネル', -1]] +
      @channels.map { |channel| [channel.name_with_prefix, channel.id] }
    @today = Time.now.to_date
    @yesterday = @today.prev_day
  end
end
