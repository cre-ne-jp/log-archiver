class Admin::ArchiveReasonsController < ApplicationController
  before_action(:require_login)

  def index
    @archive_reasons = ArchiveReason.all
  end

  def show
    @archive_reason = ArchiveReason.find(params[:id])

    page_i = params[:page].to_i
    page = page_i >= 1 ? page_i : 1
    @messages = @archive_reason.archived_conversation_messages
      .page(page)
      .order('timestamp DESC')
  end

  def new
    @archive_reason = ArchiveReason.new
  end

  def create
    @archive_reason = ArchiveReason.new(archive_reason_params_for_create)

    if @archive_reason.save
      flash[:success] = t('views.flash.added_archive_reason')
      redirect_to(admin_archive_reason_path(@archive_reason))
    else
      render(:new)
    end
  end

  def edit
    @archive_reason = ArchiveReason.find(params[:id])
  end

  def update
    @archive_reason = ArchiveReason.find(params[:id])

    if @archive_reason.update(archive_reason_params_for_create)
      flash[:success] = t('views.flash.updated_archive_reason')
      redirect_to(admin_archive_reason_path(@archive_reason))
    else
      render(:new)
    end
  end

  private

  def archive_reason_params_for_create
    params.
      require(:archive_reason).
      permit(:reason)
  end
end
