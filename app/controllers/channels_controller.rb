class ChannelsController < ApplicationController
  before_action :require_login, only: %i(new create edit update sort)

  def index
    @channels = Channel.for_channels_index
  end

  def show
    @channel = Channel.friendly.find(params[:id])
    @channels = Channel.order_for_list

    @browse_today = ChannelBrowse::Day.today(@channel)
    today_range = (@browse_today.date)...(@browse_today.date.next_day)
    @todays_speeches_count = ConversationMessage.
      where(channel: @channel, timestamp: today_range).
      count

    @browse_yesterday = ChannelBrowse::Day.yesterday(@channel)
    yesterday_range = (@browse_yesterday.date)...(@browse_yesterday.date.next_day)
    @yesterdays_speeches_count = ConversationMessage.
      where(channel: @channel, timestamp: yesterday_range).
      count

    @latest_topic = Topic.
      where(channel: @channel).
      order(timestamp: :desc).
      limit(1).
      first

    @latest_speeches = ConversationMessage.
      where(channel: @channel).
      order(timestamp: :desc).
      limit(3).
      reverse

    @years = MessageDate.
      where(channel: @channel).
      group(:year).
      order(Arel.sql('EXTRACT(YEAR FROM date)')).
      pluck(Arel.sql('EXTRACT(YEAR FROM date) AS year'))
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

  def sort
    channel = Channel.friendly.find(params[:id])
    channel.update(channel_params_for_sort)
    head(:no_content)
  end

  private

  def channel_params_for_create
    params.
      require(:channel).
      permit(:name, :identifier, :logging_enabled, :canonical_site)
  end

  def channel_params_for_update
    params.
      require(:channel).
      permit(:identifier, :logging_enabled, :canonical_site)
  end

  def channel_params_for_sort
    params.
      require(:channel).
      permit(:row_order_position)
  end
end
