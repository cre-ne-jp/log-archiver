class Channels::TodayController < ApplicationController
  def show
    channel = Channel.friendly.find(params[:id])
    browse_today = ChannelBrowse::Day.today(channel)
    redirect_to(browse_today.path)
  end
end
