# encoding: utf-8

module Backframe

  class Response

    module Adapter

      class Xml

        class << self

          def render(collection, fields)
            output  = '<?xml version="1.0"?>'
            output += "<records>"
            collection.records.each do |item|
              serialized = ActiveModelSerializers::SerializableResource.new(item).serializable_hash
              output += "<record>"
              fields.array.each do |field|
                value = Backframe::Response::Record.get_value(serialized, field[:key])
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

end
