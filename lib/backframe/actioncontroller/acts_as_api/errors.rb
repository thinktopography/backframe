module Backframe
  module ActsAsAPI
    module Errors
      def unauthenticated_request
        error_response(:unauthenticated, 401)
      end

      def unauthorized_request
        error_response(:unauthorized, 403)
      end

      def resource_not_found
        error_response(:resource_not_found, 404)
      end

      def route_not_found
        error_response(:route_not_found, 404)
      end

      private

      def error_response(code, status = 500)
        # TODO: Create generator for translations

        result = {
          error: {
            message: I18n.t("backframe.acts_as_api.#{code}", method: request.method),
            status: status
          }
        }

        render json: result, status: status
      end

      def resource_error_response(resource, status = 500)
        result = {
          message: I18n.t('backframe.acts_as_api.resource_error', request: request),
          errors: resource.errors,
          status: status
        }

        render json: result, status: status
      end
    end
  end
end
