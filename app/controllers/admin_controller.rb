class AdminController < ApplicationController
  before_action :require_login

  def index
    redirect_to(admin_status_path)
  end
end
