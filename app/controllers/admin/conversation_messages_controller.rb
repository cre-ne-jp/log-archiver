class Admin::ConversationMessagesController < ApplicationController
  before_action(:require_login)

  def show
    m = ConversationMessage.find(params[:id])
    render json: m
  end

  def update
  end

  def update
  end
end
