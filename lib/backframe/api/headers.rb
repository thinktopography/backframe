module Backframe
  module API
    module Headers
      def set_expiration_header
        headers['Last-Modified'] = Time.now.httpdate
      end
    end
  end
end
