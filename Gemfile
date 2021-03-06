source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
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
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'haml-rails', '~> 0.9.0'
gem 'slim-rails', '~> 3.0', '>= 3.0.1'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6'
gem 'test-unit'
gem 'devise'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'skim'
gem 'private_pub'
gem 'thin'
gem 'responders'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem "font-awesome-rails"
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
#gem 'delayed_job_active_record'
gem 'sidekiq'
gem 'whenever'
gem 'sinatra', '>= 1.3.0', require: nil
#gem 'sidetiq'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'dotenv'
gem 'dotenv-rails', require: 'dotenv/rails'
gem 'therubyracer'
gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rubocop', require: false
  gem 'slim_lint', '~> 0.7.2', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl', '~> 4.7', require: false
  gem 'database_cleaner'
  gem 'capybara-webkit'
  gem "letter_opener"
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
end

group :test do
   gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git'
   gem 'capybara-email'
   gem 'json_spec'
end
