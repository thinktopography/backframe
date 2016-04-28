require 'active_support'
require 'active_support/inflector'
require 'active_model_serializers'

require 'backframe/api/adapter'
require 'backframe/api/errors'
require 'backframe/api/headers'
require 'backframe/api/page'

module Backframe
  module API
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_api
        include Errors
        include Headers
        include Page

        before_action :set_expiration_header

        rescue_from Exceptions::Unauthenticated, :with => :unauthenticated_request
        rescue_from Exceptions::Unauthorized, :with => :unauthorized_request
        rescue_from 'ActiveRecord::RecordNotFound', :with => :resource_not_found
        rescue_from 'ActionController::RoutingError', :with => :route_not_found
      end
    end

    included do
      def base_api_url
        raise 'must be overridden'
      end
    end
  end
end
