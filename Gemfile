source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'mysql2'

gem "uuid", "~> 2.3.7"
gem "friendly_id", "~> 4.0.10"

gem 'crypt19-rb'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

# image handling using dragonfly
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly'

group :development do
  gem 'haml-rails'
  gem 'faker'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :github => 'anjlab/bootstrap-rails'

  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


gem 'thin'

# testing
group :test do
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'mocha'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
