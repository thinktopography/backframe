require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

require 'fixtures/active_record'
require 'fixtures/models'
require 'fixtures/serializers'
require 'fixtures/queries'
require 'fixtures/services'
require 'fixtures/seeds'
require 'backframe'

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
