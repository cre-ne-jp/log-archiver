require 'ircs/status_client'

class Admin::StatusController < ApplicationController
  before_action :require_login

  def show
    @app_status = Rails.application.config.app_status

    irc_bot_status_client = LogArchiver::Ircs::StatusClient.new(
      Rails.application.config.irc_bot_status.socket_path,
      Rails.logger
    )
    @irc_bot_status = nil
    @exception_on_fetching_irc_bot_status = nil

    begin
      @irc_bot_status = irc_bot_status_client.fetch_status(5)
    rescue => e
      @exception_on_fetching_irc_bot_status = e
    end
  end
end
