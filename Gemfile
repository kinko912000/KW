source 'https://rubygems.org'

ruby '2.2.3'

# Core Utility
gem 'rails', '4.2.4'
gem 'mysql2', '~> 0.3.20'
gem 'dotenv-rails', '1.0.2'
gem 'activerecord-import'

# Utility
gem 'http'
gem 'draper'
gem 'config'
gem 'enumerize'
gem 'opengraph_parser'
gem 'natto'
gem "delayed_job"
gem "delayed_job_active_record"
gem 'google-adwords-api'
gem 'ruby-gmail'
gem 'ransack'

# View
gem 'sass-rails', '~> 5.0', require: false
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'slim-rails'
gem 'haml-rails'
gem 'kaminari'

# JS
gem 'gon'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder', '~> 2.0'
gem 'x-editable-rails'

# rails assets
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-vue'
  gem 'rails-assets-lodash'
  gem 'rails-assets-moment'
  gem 'rails-assets-moment-transform'
  gem 'rails-assets-elevatezoom'
  gem 'rails-assets-bxslider-4'
end

# Cron
gem 'whenever', require: false

group :development do
  # debug
  gem 'ruby-debug-ide'
  gem 'web-console', '~> 2.0'
  gem 'debase'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'
  gem 'html2slim'
end

group :test do
  gem 'database_cleaner', require: false
  gem 'seed-fu', '~> 2.3'
  gem 'webmock', '~> 1.13'
  gem 'webpay-mock', require: false
  gem 'timecop'
  gem 'shoulda-matchers', require: false
  gem 'capybara-email'
end

group :development, :test do
  gem 'hirb'
  gem 'hirb-unicode'

  # js testing
  gem 'teaspoon'
  gem 'guard-teaspoon'

  # debug
  gem 'tapp'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'launchy'

  gem 'rubocop', require: false
  gem 'rubocop-rspec-focused', require: false

  gem 'brakeman', require: false

  # test
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'

  # capistrano
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
end

