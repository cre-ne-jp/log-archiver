class Admin::Channels::RefreshDigestsController < ApplicationController
  before_action(:require_login)

  def show
    RefreshDigestsJob.perform_later
    flash[:success] = t('views.flash.refreshed_digests')
    redirect_to(admin_channels_path)
  end
end
