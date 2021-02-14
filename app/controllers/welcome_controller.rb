class WelcomeController < ApplicationController
  def index
    @invalid_model = nil
    @channel_browse = ChannelBrowse.new
    @message_search = MessageSearch.new
    @message_period = MessagePeriod.new
  end
end
