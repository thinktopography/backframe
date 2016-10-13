# encoding: utf-8

module Backframe

  class Response

    module Adapter

      class Csv

        class << self

          def render(collection, separator = ",")
            records = []
            labels = []
            fields.each do |field|
              labels << field[:label]
            end
            records << labels.join(separator)
            collection.each do |item|
              record = []
              fields.each do |field|
                record << Backframe::Record.get_value(item, field[:key])
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
