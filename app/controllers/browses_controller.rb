class BrowsesController < ApplicationController
  def create
    @channel_browse = ChannelBrowse.new(params_for_create)
    @message_search = MessageSearch.new

    if @channel_browse.valid?
      browse_day = @channel_browse.to_channel_browse_day
      redirect_to(channels_day_path(browse_day.params_for_url))
    else
      @invalid_model = :channel_browse
      render 'welcome/index'
    end
  end

  private

  def params_for_create
    params.
      require(:channel_browse).
      permit(:channel, :date_type, :date)
  end
end
