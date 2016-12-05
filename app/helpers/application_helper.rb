module ApplicationHelper
  # 既定の meta タグの内容を返す
  def default_meta_tags
    {
      site: 'IRC ログアーカイブ',
      reverse: true,
      og: {
        url: request.url,
        title: :title,
        site_name: 'IRC ログアーカイブ',
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
  def linkify(s)
    Rinku.auto_link(h(s), :urls)
  end

  # 1 日分のページのパスに必要なパラメータのハッシュを返す
  def channels_day_path_params(channel, date)
    {
      identifier: channel.identifier,
      year: date.year,
      month: '%02d' % date.month,
      day: '%02d' % date.day
    }
  end
end
