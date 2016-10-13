# encoding: utf-8

module Backframe

  class Response

    module Adapter

      class Json

        class << self

          def render(collection, fields)
            data = {
              records: [],
              total_records: collection.total_records,
              current_page: collection.current_page,
              total_pages: collection.total_pages
            }
            collection.records.each do |item|
              serialized = ActiveModelSerializers::SerializableResource.new(item).serializable_hash
              if fields.any?
                record = {}
                fields.array.each do |field|
                  obj = record
                  parts = field[:key].split(".")
                  value = Backframe::Response::Record.get_value(serialized, field[:key])
                  parts.each_with_index do |part, index|
                    if index == parts.size - 1
                      obj[part.to_sym] = value
                    else
                      obj[part.to_sym] ||= {}
                      obj = obj[part.to_sym]
                    end
                  end
                end
                data[:records] << record
              else
                data[:records] << serialized
              end
            end
            data
          end

        end

      end

    end

  end

end
