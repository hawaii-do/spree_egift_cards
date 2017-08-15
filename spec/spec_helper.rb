# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

begin
  require File.expand_path('../../dummy/config/environment', __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
  exit
end

require 'rspec/rails'
require 'rspec/active_model/mocks'
require 'ffaker'
require 'pry'
require 'database_cleaner'
require 'factory_girl'
require File.expand_path('../../factories', __FILE__)
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/controller_requests'

require 'spree/api/testing_support/caching'
require 'spree/api/testing_support/helpers'
require 'spree/api/testing_support/setup'


def current_admin_user
  @current_api_user ||= model_model(Spree.user_class, email: "spree@example.com")
end

def stub_api_authentication!
  allow_any_instance_of(Spree::Api::BaseController).to receive(:authenticate_user) {current_api_user}
  allow_any_instance_of(Spree::User).to receive(:send_admin_mail)
end

def stub_current_store!
  allow_any_instance_of(Spree::Api::V1::EgiftCardsController).to receive(:current_store) {Spree::Store.first}
end


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::Api::TestingSupport::Helpers, :type => :controller
  config.extend Spree::Api::TestingSupport::Setup, :type => :controller

  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.fail_fast = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |file| require file }