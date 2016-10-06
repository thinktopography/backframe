# encoding: utf-8

module Backframe

  module Response

    class Xml

      class << self

        def render(collection)
          data = self.format(collection)
          { json: data, content_type: 'application/xhtml+xml', status: 200 }
        end

        def format(collection)
          output  = '<?xml version="1.0"?>'
          recordsname = collection.first.class.name.tableize
          recordname = collection.first.class.name.tableize.singularize
          output += "<#{recordsname}>"
          collection.each do |record|
            output += "<#{recordname}>"
            output += "<id>#{record.id}</id>"
            output += "</#{recordname}>"
          end
          output += "</#{recordsname}>"
          output
        end

      end

    end

  end

end
