# encoding: utf-8

module Backframe

  module Response

    class Json

      class << self

        def render(collection, fields)
          { json: collection, content_type: 'application/json', status: 200 }
        end

      end

    end

  end

end
