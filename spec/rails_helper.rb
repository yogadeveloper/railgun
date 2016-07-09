require 'capybara/email/rspec'
require 'shoulda-matchers'
require 'bundler/setup'
require 'cancan/matchers'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

# require 'delayed_job_active_record'

::Bundler.require(:default, :test)

::Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'spec_helper'
require 'factory_girl'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  # config.before do
  #   Delayed::Worker.delay_jobs = false
  # end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:each, type: :sphinx) do
    DatabaseCleaner.strategy = :truncation
  end

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
  FactoryGirl.find_definitions

  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller

  Capybara::Webkit.configure do |config|
    config.block_unknown_urls
  end
end
