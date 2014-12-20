# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'rspec/autorun'
require 'webmock/rspec'
require 'sidekiq/testing'
require 'vcr'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/factories/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# Allow to simulate signed in user whit Capybara
include Warden::Test::Helpers
Warden.test_mode!

SITES = {
  "main_example" => "http://skelz0r.fr/tiny_listing/",
  "empty" => "http://skelz0r.fr/tiny_listing/empty",
  "not_a_repository" => "http://www.google.fr",
  "403" => "http://lepetit.iiens.net/SIA/"
}

NUMBER_OF_FILES = {
  "main_example" => 7
}

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
  # c.debug_logger = Rails.logger
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include FactoryGirl::Syntax::Methods
  config.extend VCR::RSpec::Macros

  config.before(:all) do
    $redis.flushdb
    User.delete_all
    Loot.delete_all
    Repository.delete_all
  end

  config.before(:each, sidekiq: :inline) do
    Sidekiq::Testing.inline!
  end

  config.before(:each, sidekiq: :disable) do
    Sidekiq::Testing.disable!
  end

  config.after(:each) do
    Sidekiq::Testing.fake!
  end

  config.after(:each) do
    User.delete_all
    Loot.delete_all
    Repository.delete_all
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:all) do
    [Loot, Repository].each do |m|
      m.delete_all
    end
  end
end
