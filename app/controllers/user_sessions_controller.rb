class UserSessionsController < ApplicationController
  before_action(:require_login, only: %i(destroy))

  def new
    @user = User.new
  end

  def create
    @user = login(params[:username], params[:password])
    if @user
      redirect_back_or_to(root_path, success: t('views.flash.login_successful'))
    else
      flash.now[:danger] = t('views.flash.login_failed')
      render('new')
    end
  end

  def destroy
    logout

    flash[:success] = t('views.flash.logged_out')
    redirect_to(root_path)
  end
end
