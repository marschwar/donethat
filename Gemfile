source 'https://rubygems.org'

ruby '2.1.6'

gem 'rails'

gem 'mysql2'

# multi threaded webserver
gem 'puma'
gem 'lograge'
gem 'activerecord-session_store'

gem "uuid"
gem "friendly_id"

gem 'crypt19-rb'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

gem 'carrierwave'
gem 'mini_magick'
gem 'fog', '~> 1.0'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'twitter-bootstrap-rails'
gem 'less-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :development do
  gem 'haml-rails'
  gem 'faker'
  gem 'quiet_assets'
end

# testing
group :test do
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'mocha'
end

group :production do
  # see https://devcenter.heroku.com/articles/rails4
  gem 'rails_12factor'
  gem 'pg'
end
