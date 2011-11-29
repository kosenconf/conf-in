source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.1.3'
gem 'devise', '1.5.1'
gem 'haml-rails', '0.3.4'
gem 'rails-i18n', '0.1.11'
gem 'rmagick', '2.13.1'
gem 'jquery-rails', '1.0.19'
gem 'twitter-bootstrap-rails', '1.4.1'


group :production do
	gem 'mysql2', '0.3.10'
end

group :development, :test do
	gem 'sqlite3', '1.3.4'
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
