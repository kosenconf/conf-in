source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.1.1'
gem 'devise'
gem 'haml-rails'
gem 'rails-i18n'
gem 'rmagick'
gem 'jquery-rails'

group :production do
	gem 'mysql2'
end

group :development, :test do
	gem 'sqlite3'
	gem 'ruby-debug19', require: 'ruby-debug'
end

group :development do
	gem 'heroku', require: nil
	gem 'capistrano', require: nil
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.4"
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier', '>= 1.0.3'
end


group :test do
	gem 'turn', require: false
	gem 'minitest'
end
