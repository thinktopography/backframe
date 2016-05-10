# encoding: utf-8

module Backframe
  module ActsAsAPI
    module Headers
      def set_expiration_header
        headers['Last-Modified'] = Time.now.httpdate
      end
    end
  end
end
