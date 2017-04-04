class Messages::SearchesController < ApplicationController
  def create
    @message_search = MessageSearch.new(params_for_create)
    @channel_browse = ChannelBrowse.new

    if @message_search.valid?
      redirect_to(
        messages_search_path(@message_search.attributes_for_result_page)
      )
    else
      @invalid_model = :message_search
      render 'welcome/index'
    end
  end

  def show
    @message_search = MessageSearch.new
    @message_search.set_attributes_with_result_page_params(params_for_show)

    @channel_browse = ChannelBrowse.new

    if @message_search.valid?
      @result = @message_search.result
    else
      @invalid_model = :message_search
      render 'welcome/index'
    end
  end

  private

  def params_for_create
    result = params.
      require(:message_search).
      permit(:query, :nick, :since, :until, channels: [])

    channels = result['channels']
    channels.select!(&:present?) if channels

    result
  end

  def params_for_show
    params.permit(:q, :nick, :channels, :since, :until, :page)
  end
end
