class BrowsesController < ApplicationController
  def create
    @channel_browse = ChannelBrowse.new(params_for_create)
    @message_search = MessageSearch.new

    if @channel_browse.valid?
      browse_day = @channel_browse.to_channel_browse_day
      browse_day.style = self.class.helpers.message_list_style(cookies)
      redirect_to(browse_day.path)
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
