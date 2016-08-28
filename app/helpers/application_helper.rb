module ApplicationHelper
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

  def message_or_period(m)
    m.message.blank? ? '。' : "：#{m.message}"
  end
end
