require "codeclimate-test-reporter"

ENV['CODECLIMATE_REPO_TOKEN'] = "ff5eff2f4068518c0d38d88f8065b28a6b1513e55226f0a2a150ea84878cee2c"
CodeClimate::TestReporter.start

require 'backframe'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
