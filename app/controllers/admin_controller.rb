# development環境で正常にリロードするために必要
require_dependency 'log_archiver/app_status'

class AdminController < ApplicationController
  before_action :require_login

  def index
  end
end
