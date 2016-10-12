# encoding: utf-8

module Backframe

  module Adapter

    class Json

      class << self

        def render(collection, fields)
          data = format(collection, fields)
          { json: data, content_type: 'application/json', status: 200 }
        end

        def format(collection, fields)
          records = []
          collection.each do |item|
            record = {}
            fields.each do |field|
              obj = record
              parts = field[:key].split(".")
              if value = Backframe::Record.get_value(item, field[:key])
                parts.each_with_index do |part, index|
                  if index == parts.size - 1
                    obj[part.to_sym] = value
                  else
                    obj[part.to_sym] ||= {}
                    obj = obj[part.to_sym]
                  end
                end
              end
            end
            records << record
          end
          records
        end
      end

    end

  end

end
