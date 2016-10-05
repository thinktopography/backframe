# encoding: utf-8

module Backframe

  module Response

    class Error

      def self.render(collection)
        { text: 'Unknown format', content_type: 'text/plain', status: 404 }
      end

    end

  end

end