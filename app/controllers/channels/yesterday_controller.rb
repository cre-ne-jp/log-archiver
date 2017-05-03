class Channels::YesterdayController < ApplicationController
  def show
    channel = Channel.friendly.find(params[:id])
    browse_yesterday = ChannelBrowse::Day.yesterday(channel)
    redirect_to(browse_yesterday.path)
  end
end
