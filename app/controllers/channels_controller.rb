class ChannelsController < ApplicationController
  before_action :require_login, only: %i(new create edit update)

  def index
    @channels = Channel.for_channels_index
  end

  def show
    @channel = Channel.friendly.find(params[:id])
    unless @channel
      raise ArgumentError, "Channel not found: #{params[:identifier]}"
    end

    @years = MessageDate.
      uniq.
      where(channel: @channel).
      pluck('YEAR(date)')
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params_for_create)

    if @channel.save
      flash[:success] = t('views.flash.added_channel')
      redirect_to(admin_channel_path(@channel))
    else
      render(:new)
    end
  end

  def edit
    @channel = Channel.friendly.find(params[:id])
  end

  def update
    @channel = Channel.friendly.find(params[:id])

    if @channel.update_attributes(channel_params_for_update)
      flash[:success] = t('views.flash.updated_channel')
      redirect_to(admin_channel_path(@channel))
    else
      render(:edit)
    end
  end

  private

  def last_speech_timestamp(channel)
    channel.last_speech&.timestamp || DateTime.new
  end

  def channel_params_for_create
    params.
      require(:channel).
      permit(:name, :identifier, :logging_enabled)
  end

  def channel_params_for_update
    params.
      require(:channel).
      permit(:identifier, :logging_enabled)
  end
end
