class WelcomeController < ApplicationController
  def index
    @channels = Channel.select(:id, :identifier, :name)
    @channel_data_for_select =
      @channels.map { |channel| [channel.name_with_prefix, channel.identifier] }
    @today = Time.now.to_date
    @yesterday = @today.prev_day
  end
end
