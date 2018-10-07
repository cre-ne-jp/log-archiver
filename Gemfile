source 'https://rubygems.org'

# IRC framework
gem 'cinch'
gem 'lumberjack'
gem 'sysexits'
gem 'xmlrpc'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.2'
#gem 'activerecord-mysql-awesome'
#gem 'activerecord-mysql-comment'

gem 'activerecord-import'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0.0', group: :doc

# デザイン
gem 'bootstrap-sass'
gem 'font-awesome-rails'

# SEO
gem 'meta-tags'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# カレンダー
gem "simple_calendar", "~> 2.0"
gem 'momentjs-rails', '~> 2.15'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17'

# Markdown パーサ
gem 'redcarpet'

# 自動リンク
# スキーム付きのURLのみ有効にするために独自ブランチを使用する
gem 'rinku', git: 'https://github.com/cre-ne-jp/rinku.git', branch: 'without-www'

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

# グラフ描画
gem 'chart-js-rails'

# コンソールとして pry を使う
gem 'pry-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'minitest-reporters'

  gem 'guard'
  gem 'guard-minitest'

  # @see https://railsguides.jp/upgrading_ruby_on_rails.html#%E3%81%84%E3%81%8F%E3%81%A4%E3%81%8B%E3%81%AE%E3%83%98%E3%83%AB%E3%83%91%E3%83%BC%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%82%92-rails-controller-testing-%E3%81%AB%E6%8A%BD%E5%87%BA
  gem 'rails-controller-testing'

  # テスト時の対象オブジェクト作成
  gem 'factory_bot_rails', require: false
end

group :test do
  gem 'rake'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
