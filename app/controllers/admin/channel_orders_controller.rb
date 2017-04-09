class Admin::ChannelOrdersController < ApplicationController
  before_action(:require_login)

  def show
    @channels = Channel.order_for_list
  end
end
