class UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = t('views.flash.added_user')
      redirect_to(users_path)
    else
      render(:new)
    end
  end

  def show
    @user = User.friendly.find(params[:id])
    @can_edit = (current_user == @user)
    @can_remove = (current_user != @user)
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
    old_username = @user.username

    if @user.update_attributes(user_params)
      flash[:success] = t('views.flash.updated_user')
      redirect_to(users_path)
    else
      @user.username = old_username
      render(:edit)
    end
  end

  private

  def user_params
    params.
      require(:user).
      permit(:username, :password, :password_confirmation)
  end
end
