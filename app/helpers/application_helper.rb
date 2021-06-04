module ApplicationHelper
  include FlatpickrHelper
  include FontawesomeHelper

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

  # mIRC 装飾制御文字を HTML に変換する
  # @param [String] mirc mIRC 装飾制御文字を含むメッセージ
  # @return [String]
  def convert_mirc_to_html(mirc)
    LogArchiver::MircToHtml.new(mirc).parse.render
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

  # キーワードコマンド .a で出力された Amazon.co.jp 商品リンクに含まれる
  # アフィリエイトタグを、設定されたタグに差し替える
  # @param [ConversationMessage] m
  # @return [String]
  def replace_amazon_affiliate_tag(m)
    settings = Setting.get
    old_affiliate_tags = settings.target_amazon_affiliate_tags
    new_affiliate_tag = settings.amazon_affiliate_tag
    return m.message if old_affiliate_tags.empty? || new_affiliate_tag.blank?
    return m.message unless settings.nicks_target_affiliate_message_by.include?(m.nick.downcase)

    m.message.gsub(/(#{old_affiliate_tags.join('|')})/, new_affiliate_tag)
  end
end
