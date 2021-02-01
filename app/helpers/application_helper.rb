module ApplicationHelper
  include FlatpickrHelper

  # サイト名を返す
  def site_title
    @setting ||= Setting.get
    @site_title ||= @setting.site_title
  end

  # 既定の meta タグの内容を返す
  # @return [Hash]
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
    last_speech = channel.last_speech
    if last_speech
      browse_day = ChannelBrowse::Day.new(
        channel: channel,
        date: last_speech.timestamp.to_date,
        style: message_list_style(cookies)
      )

      link_to(last_speech.timestamp.strftime('%F %T'),
              browse_day.path(anchor: last_speech.fragment_id))
    else
      '発言なし'
    end
  end

  # タブがアクティブかどうかを示すクラス名を返す
  # @return [String]
  def nav_tab_class(cond)
    cond ? 'active' : ''
  end

  # PRIVMSGのキーワード部分にリンクを設定する
  # @param [Privmsg] privmsg キーワードコマンドのPRIVMSG
  # @param [Keyword] keyword 対応するキーワード
  # @return [String]
  def linkify_keyword(privmsg, keyword)
    m = privmsg.message.match(/([ 　]+)/)
    return sanitize(privmsg.message) unless m

    command = m.pre_match
    separator = m[1]
    keyword_title = m.post_match

    pre_keyword = sanitize("#{command}#{separator}")
    link_to_keyword = link_to(sanitize(keyword_title), keyword_path(keyword))

    raw("#{pre_keyword}#{link_to_keyword}")
  end
end
