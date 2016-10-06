# encoding: utf-8

module Backframe

  module Params

    class Sort

      class << self

        def parse(sort_string = nil)
          sort = []
          sort_string ||= '-created_at'
          sort_string.split(',').each do |token|
            token.strip!
            key = (token[0] == '-') ? token[1..-1] : token
            order = (token[0] == '-') ? 'desc' : 'asc'
            sort << { key: key, order: order }
          end
          sort
        end

      end

    end

  end

end
