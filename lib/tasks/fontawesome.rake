# frozen_string_literal: true

namespace :fontawesome do
  desc '使用中のFont Awesomeアイコンを一覧表示する'
  task :list do
    grep_result = `git grep -o -P "\\bfa_icon\\('[^']+'"`
    icons = grep_result.each_line.map { |l| (l.match(/'([^']+)'/).to_a)[1] }
    puts(icons.compact.sort.uniq)
  end
end
