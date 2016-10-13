# encoding: utf-8

module Backframe

  module Adapter

    class Xml

      class << self

        def render(collection, fields)
          output  = '<?xml version="1.0"?>'
          output += "<records>"
          collection.each do |item|
            output += "<record>"
            fields.each do |field|
              value = Backframe::Record.get_value(item, field[:key])
              output += "<#{field[:key]}>#{value}</#{field[:key]}>"
            end
            output += "</record>"
          end
          output += "</records>"
          output
        end

      end

    end

  end

end
