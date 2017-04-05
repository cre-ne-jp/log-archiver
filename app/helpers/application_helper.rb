module ApplicationHelper
  # サイト名を返す
  def site_title
    @setting ||= Setting.get
    @site_title ||= @setting.site_title
  end

  # 既定の meta タグの内容を返す
  def default_meta_tags
    {
      site: site_title,
      reverse: true,
      og: {
        url: request.url,
        title: :title,
        site_name: site_title,
        description: :description,
        locale: 'ja_JP'
      }
    }
  end

  # メッセージがあればメッセージを、なければ句点を返す
  def message_or_period(m)
    m.message.blank? ? '。' : "：#{m.message}"
  end

  # 自動でリンクを張る
  #
  # スキーム付きの部分のみにリンクが張られるように
  # 独自のオプションを渡す。
  def linkify(s)
    Rinku.auto_link(h(s), :urls_without_www)
  end

  # Markdown ソースを HTML ソースに変換する
  # @param [String] source Markdown ソース
  # @return [String]
  def markdown(source)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      disable_indented_code_blocks: true,
      strikethrough: true,
      underline: true,
      highlight: true
    )

    markdown.render(source).html_safe
  end

  # チャンネルの最終発言日時へのリンクを返す
  def last_speech_timestamp_link(channel)
    if last_speech = channel.last_speech
      browse_day = ChannelBrowse::Day.new(
        channel: channel, date: last_speech.timestamp.to_date
      )

      link_to(
        last_speech.timestamp.strftime('%F %T'),
        channels_day_path(
          browse_day.params_for_url.merge({ anchor: last_speech.id })
        )
      )
    else
      '発言なし'
    end
  end
end
