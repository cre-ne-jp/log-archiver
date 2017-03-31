class UserSessionsController < ApplicationController
  before_action(:require_login, only: %i(destroy))

  def new
    @user = User.new
  end

  def create
    @user = login(params[:username], params[:password])
    if @user
      redirect_back_or_to(users_path, success: t('views.flash.login_successful'))
    else
      flash.now[:danger] = t('views.flash.login_failed')
      render('new')
    end
  end

  def destroy
    logout
    redirect_to(root_path, info: 'views.flash.logged_out')
  end
end
