class Messages::SearchesController < ApplicationController
  def create
    @message_search = MessageSearch.new(params_for_create)

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

    if @message_search.valid?
      @result = @message_search.result
    else
      @invalid_model = :message_search
      render 'welcome/index'
    end
  end

  private

  def params_for_create
    params.
      require(:message_search).
      permit(:query, :channel, :since, :until)
  end

  def params_for_show
    params.permit(:q, :channel, :since, :until, :page)
  end
end
