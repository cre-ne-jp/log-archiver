class UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User.all
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def edit
  end

  private

  def user_params
    params.
      require(:user).
      permit(:username, :password, :password_confirmation)
  end
end
