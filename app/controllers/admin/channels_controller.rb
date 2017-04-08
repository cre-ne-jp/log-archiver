class Admin::ChannelsController < ApplicationController
  before_action(:require_login)

  def index
    @channels = Channel.all
  end

  def show
    @channel = Channel.friendly.find(params[:id])
  end
end
