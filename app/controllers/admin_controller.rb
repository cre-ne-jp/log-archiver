class AdminController < ApplicationController
  before_action :require_login

  def index
    @booted_at = Rails.application.config.booted_at
    @uptime = Time.now - @booted_at
  end
end
