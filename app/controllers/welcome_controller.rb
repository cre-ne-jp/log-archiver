class WelcomeController < ApplicationController
  def index
    @setting = Setting.get

    @invalid_model = nil
    @channel_browse = ChannelBrowse.new
    @message_search = MessageSearch.new
  end
end
