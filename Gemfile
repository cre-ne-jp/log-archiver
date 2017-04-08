source 'https://rubygems.org'

# IRC framework
gem 'cinch'
gem 'lumberjack'
gem 'sysexits'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.7'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
gem 'activerecord-mysql-awesome'
gem 'activerecord-mysql-comment'

gem 'activerecord-import'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

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

# コンソールとして pry を使う
gem 'pry-rails'

# ruby2.4
# https://github.com/rails/rails/issues/27450
#gem 'json', github: 'flori/json', branch: 'v1.8'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'minitest-reporters'

  gem 'guard'
  gem 'guard-minitest'

  # テスト時の対象オブジェクト作成
  gem 'factory_girl_rails', require: false
end

group :test do
  gem 'rake'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
