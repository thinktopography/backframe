# encoding: utf-8

module Backframe

  module Response

    class Json

      def self.render(collection)
        { json: collection, content_type: 'application/json', status: 200 }
      end

    end

  end

end
