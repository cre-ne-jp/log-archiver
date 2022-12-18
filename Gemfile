source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# IRC framework
gem 'mcinch'
gem 'lumberjack'
gem 'sysexits'
gem 'xmlrpc'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'

# メールクライアント
# Ruby 3.1 系列から標準ライブラリでなくなった
gem 'net-smtp'

# バルクアップデートに使う
gem 'activerecord-import'

# Use SCSS for stylesheets
gem 'sassc-rails', '>= 2.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use Webpack to manage app-like JavaScript modules in Rails
gem 'webpacker', '~> 5.x'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0', group: :doc

# デザイン
gem 'bootstrap-sass', '>= 3.4.1'

# SEO
gem 'meta-tags'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma', '< 6.0'
gem 'puma_worker_killer'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', '< 1.10', require: false

# カレンダー
gem "simple_calendar", "~> 2.0"

# Markdown パーサ
gem 'redcarpet'

# 自動リンク
# スキーム付きのURLのみ有効にするために独自ブランチを使用する
gem 'rinku', github: 'cre-ne-jp/rinku', branch: 'without-www'

# ページネーション
gem 'kaminari'

# URLで番号の代わりに分かりやすい識別子を使う
gem 'friendly_id'

# ActiveModelでenumを使う
gem 'simple_enum'

# 認証
gem 'sorcery'

# 並び替え
gem 'ranked-model'

# 高速なハッシュ関数ライブラリ
gem 'cfnv'

# コンソールとして pry を使う
gem 'pry-rails'

# ナビゲーションの定義
gem 'simple-navigation'

# ActiveJob バックエンド
gem 'sidekiq', '< 7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'guard'
  gem 'guard-minitest'

  # @see https://railsguides.jp/upgrading_ruby_on_rails.html#%E3%81%84%E3%81%8F%E3%81%A4%E3%81%8B%E3%81%AE%E3%83%98%E3%83%AB%E3%83%91%E3%83%BC%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%82%92-rails-controller-testing-%E3%81%AB%E6%8A%BD%E5%87%BA
  gem 'rails-controller-testing'

  # テスト時の対象オブジェクト作成
  gem 'factory_bot_rails', require: false
end

group :test do
  gem 'test-unit-rails'

  gem 'database_cleaner-active_record'

  gem 'rake'
  gem 'rubocop'
  gem 'rubocop-rails'

  # Workaround for cc-test-reporter with SimpleCov 0.18.
  # Stop upgrading SimpleCov until the following issue will be resolved.
  # https://github.com/codeclimate/test-reporter/issues/418
  gem 'simplecov', '~> 0.10', '< 0.18'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
