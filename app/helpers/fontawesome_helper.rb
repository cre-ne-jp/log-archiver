module FontawesomeHelper
  def fa_icon(names = 'flag', original_options = {})
    options = original_options.deep_dup
    names = names.is_a?(Array) ? names : names.to_s.split(/\s+/)
    classes = %w(fa)
    classes.concat(names.map { |n| "fa-#{n}" })
    classes.concat(Array(options.delete(:class)))
    text = options.delete(:text)
    right = options.delete(:right)
    icon = content_tag(:i, nil, options.merge(:class => classes))

    return icon if text.blank?
    elements = [icon, ERB::Util.html_escape(text)]
    elements.reverse! if right
    safe_join(elements, ' ')
  end
end
