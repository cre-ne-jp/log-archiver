# メッセージの検索についてのコントローラ
class Messages::PeriodsController < ApplicationController
  # 前後の検索結果ページのパスの生成等に使用する
  include Kaminari::Helpers::HelperMethods
  # ナビゲーション用のメタ情報を
  include NavLinkSettable

  # 検索クエリを作成する
  #
  # 有効なクエリならば #show で検索結果ページを表示するようにリダイレクト
  # する。
  #
  # 無効なクエリならばホームページの検索フォームが見えるように描画する。
  def create
    @message_period = MessagePeriod.new(params_for_create)

    if @message_period.valid?
      redirect_to(
        messages_period_path(@message_period.attributes_for_result_page)
      )
    else
      @invalid_model = :message_period
      @channel_browse = ChannelBrowse.new
      @message_search = MessageSearch.new
      render 'welcome/index'
    end
  end

  # 検索結果ページを表示する
  #
  # 有効なクエリならばデータベースから検索して結果を表示する。
  # ナビゲーション用のメタ情報も検索結果から用意する。
  #
  # 無効なクエリならばホームページの検索フォームが見えるように描画する。
  def show
    @message_period = MessagePeriod.new
    @message_period.set_attributes_with_result_page_params(params_for_show)

    if @message_period.valid?
      @result = @message_period.result
      @conversation_messages = @result.conversation_messages
      @privmsg_keyword_relationships =
        privmsg_keyword_relationships_from(@conversation_messages)

      set_prev_link!(path_to_prev_page(@conversation_messages))
      set_next_link!(path_to_next_page(@conversation_messages))

      i = 0
      @messages = (@result.messages.to_a + @conversation_messages.to_a).
        sort_by { |m| [m.timestamp, i += 1] }
    else
      @invalid_model = :message_period
      @channel_browse = ChannelBrowse.new
      @message_search = MessageSearch.new
      render 'welcome/index'
    end
  end

  private

  # create で使用できるパラメータを返す
  # @return [ActionController::Parameters]
  def params_for_create
    result = params.
      require(:message_period).
      permit(:since, :until, channels: [])

    channels = result['channels']
    channels.select!(&:present?) if channels

    result
  end

  # show で使用できるパラメータを返す
  # @return [ActionController::Parameters]
  def params_for_show
    params.permit(:channels, :since, :until, :page)
  end
end
