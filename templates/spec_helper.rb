require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'nulldb_rspec'

  ActiveRecord::Base.establish_connection :adapter => :nulldb

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true

    if ENV['FAST_TESTS']
      config.filter_run_excluding :db => true
      config.filter_run_excluding :request => true
    end

    config.before(:all, :db => true) do 
      ActiveRecord::Base.establish_connection :test
    end

    config.after(:all, :db => true) do
      ActiveRecord::Base.establish_connection :adapter => :nulldb
    end
  end
end

Spork.each_run do
end

