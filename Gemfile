source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Core
gem 'figaro'
gem 'jbuilder'
gem 'json', '2.0.2'
gem 'pg', '~> 0.20'
gem 'puma'
gem 'rack-cors'
gem 'rack-utf8_sanitizer'
gem 'rails', '5.1.4'
gem 'redis'
gem 'redis-rails'

# Enhacements
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-cron'

# Addons
gem 'devise', '~> 4.3.0'
gem 'money-rails'
gem 'nokogiri'
gem 'rails-i18n'
gem 'simple_form', '~> 3.5'
gem 'sitemap_generator'

# Emails
gem 'email_validator'
gem 'mailkick', github: 'lewagon/mailkick' # Gibbon compatibility
gem 'ahoy_email'
gem 'gibbon'

# Assets
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'critical-path-css-rails'
gem 'font-awesome-sass'
gem 'jquery-rails'
gem 'js-routes'
gem 'lodash-rails'
gem 'mini_magick', require: false # Require only in ProxyController
gem 'react-bootstrap-rails'
gem 'react-rails', '1.10.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier'
gem 'momentjs-rails'

# Api Clients
gem 'appsignal'
gem "graphql-client"
gem 'linkedin-oauth2', '~> 1.0'
gem 'meetup_client'
gem 'omniauth-github'
gem 'rest-client'
gem 'ruby-trello'

# Markdown
gem 'pygmentize'
gem 'redcarpet'

# Images
gem 'attachinary', github: 'assembler/attachinary'
gem 'cloudinary'
gem 'jquery-fileupload-rails'

# Pagination
gem 'kaminari'

source 'https://rails-assets.org' do
  gem 'rails-assets-classnames'
  gem 'rails-assets-devicons'
  gem 'rails-assets-headroom.js'
  gem 'rails-assets-mdi'
  gem 'rails-assets-pubsub-js'
end

group :development, :test do
  gem 'letter_opener'
  gem 'rspec-rails', '~> 3.6'
  gem 'spring'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'annotate'
  gem 'httplog'
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'rspec-sidekiq'
end
