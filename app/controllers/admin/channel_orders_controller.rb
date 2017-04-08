class Admin::ChannelOrdersController < ApplicationController
  before_action(:require_login)

  def show
    @channels = Channel.rank(:row_order)
  end
end
