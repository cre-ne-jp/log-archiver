class Admin::ChannelsController < ApplicationController
  before_action(:require_login)

  def index
    @channels = Channel.rank(:row_order)
  end

  def show
    @channel = Channel.friendly.find(params[:id])
  end
end
