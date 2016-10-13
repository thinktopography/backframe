# encoding: utf-8

module Backframe

  class Response

    module Adapter

      class Csv

        class << self

          def render(collection, fields, separator = ",")
            records = []
            labels = []
            fields.array.each do |field|
              labels << field[:label]
            end
            records << labels.join(separator)
            collection.records.each do |item|
              serialized = ActiveModelSerializers::SerializableResource.new(item).serializable_hash
              record = []
              fields.array.each do |field|
                record << Backframe::Response::Record.get_value(serialized, field[:key])
              end
              records << record.join(separator)
            end
            records.join("\n")
          end

        end

      end

    end

  end

end
