# encoding: utf-8

module Backframe

  module Adapter

    class Xml

      class << self

        def render(collection, fields)
          data = self.format(collection, fields)
          { xml: data, content_type: 'application/xhtml+xml', status: 200 }
        end

        def format(collection, fields)
          output  = '<?xml version="1.0"?>'
          recordsname = collection.first.class.name.tableize
          recordname = collection.first.class.name.tableize.singularize
          output += "<records>"
          collection.each do |item|
            output += "<record>"
            fields.each do |field|
              if value = Backframe::Record.get_value(item, field[:key])
                output += "<#{field[:key]}>#{value}</#{field[:key]}>"
              end
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
