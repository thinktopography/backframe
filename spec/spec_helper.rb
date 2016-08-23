ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'backframe'

require 'action_controller/railtie'
require 'active_model_serializers'
require 'active_model_serializers/railtie'
require 'active_record'
require 'factory_girl'
require 'kaminari'
require 'rspec/rails'

LOGGER = Logger.new('/dev/null')

Rails.logger = LOGGER
ActiveModelSerializers.logger = LOGGER
ActiveRecord::Base.logger = LOGGER

DATABASE = {
  adapter: 'sqlite3',
  database: ':memory:'
}

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(DATABASE)

module Backframe
  class Application < ::Rails::Application
    def self.find_root(from)
      Dir.pwd
    end

    config.eager_load = false
    config.secret_key_base = 'secret'
  end
end

Backframe::Application.initialize!
Backframe::Mime.register_types

module Helpers
  def json_response
    @json_response ||= JSON.parse(response.body).with_indifferent_access
  end

  def serialize(value, opts = {})
    opts[:adapter] ||= Backframe::ActsAsAPI::Adapter
    ActiveModel::SerializableResource.new(value, opts).as_json
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.include Rails.application.routes.url_helpers
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = true
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
