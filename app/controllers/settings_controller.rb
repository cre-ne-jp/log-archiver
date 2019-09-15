class SettingsController < ApplicationController
  before_action :require_login

  def edit
    @setting = Setting.get
    @target_setting = @setting
  end

  def update
    @setting = Setting.get
    old_site_title = @setting.site_title

    if @setting.update(setting_params)
      flash[:success] = t('views.flash.updated_settings')
      redirect_to(admin_path)
    else
      @setting.site_title = old_site_title
      render(:edit)
    end
  end

  private

  def setting_params
    params.
      require(:setting).
      permit(:site_title, :text_on_homepage)
  end
end
