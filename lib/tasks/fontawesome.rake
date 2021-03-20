# frozen_string_literal: true

namespace :fontawesome do
  desc '使用中のFont Awesomeアイコンを一覧表示する'
  task :list do
    puts(used_fontawesome_icons)
  end

  desc 'Font Awesomeアイコンを使用するためのJavaScriptを出力する'
  task :js_config do
    items_for_import = used_fontawesome_icons.map { |i| "fa#{i.underscore.camelize}" }
    ERB.new(USE_FONTAWESOME_JS_ERB, trim_mode: 2).run(binding)
  end

  def used_fontawesome_icons
    grep_result = `git grep -o -P "\\bfa_icon\\('[^']+'"`
    icons = grep_result.each_line.map { |l| (l.match(/'([^']+)'/).to_a)[1] }

    icons.compact.sort.uniq
  end

  USE_FONTAWESOME_JS_ERB = <<~ERB
    library.add(
    <% items_for_import.each do |i| %>
      <%= i %>,
    <% end %>
    );
  ERB
end
