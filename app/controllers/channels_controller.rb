class ChannelsController < ApplicationController
  def index
    @channels = Channel.all
  end

  def show
    @channel = Channel.find(params[:id])
    @messages = @channel.messages.order(:timestamp, :id)
  end
end
