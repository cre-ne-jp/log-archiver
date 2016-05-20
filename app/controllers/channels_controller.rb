class ChannelsController < ApplicationController
  def index
  end

  def show
    @channel = Channel.find_by(params[:id])
  end
end
