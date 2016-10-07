# encoding: utf-8

module Backframe

  module Adapter

    class Json

      class << self

        def render(collection, _fields)
          { json: collection, content_type: 'application/json', status: 200 }
        end

      end

    end

  end

end
