source 'https://rubygems.org'

gem 'rails', '~> 4.2.0.rc2'

gem 'pg'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'haml-rails'

gem 'bootstrap-sass', '~> 3.0'
gem "font-awesome-rails"

gem 'devise'

gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'

gem "nokogiri"
gem "addressable"
gem 'textacular', '~> 3.0'

gem "sidekiq"
gem "interactor", "~> 3.0"

group :test do
  gem 'capybara'
  gem 'rspec-rails'
  gem 'webmock'
  gem 'factory_girl'
  gem 'vcr'
  gem 'rake'
  gem 'shoulda-matchers', require: false
end

group :development do
  gem "spring"
  gem "spring-commands-rspec"
end

# Deploiement
group :development do
  gem 'mina', git: "https://github.com/mina-deploy/mina.git"
  gem 'mina-sidekiq', git: "https://github.com/Mic92/mina-sidekiq.git"
end

group :development, :test do
  gem 'pry-byebug'
end
