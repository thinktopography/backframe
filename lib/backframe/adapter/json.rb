# encoding: utf-8

module Backframe

  module Adapter

    class Json

      class << self

        def render(collection, fields, total_records = nil, current_page = nil, total_pages = nil)
          data = { records: [] }
          collection.each do |item|
            record = {}
            fields.each do |field|
              obj = record
              parts = field[:key].split(".")
              value = Backframe::Record.get_value(item, field[:key])
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
          end
          data[:total_records] = total_records || collection.size
          if current_page
            data[:current_page] = current_page
          end
          if total_pages
            data[:total_pages] = total_pages
          end
          data
        end

      end

    end

  end

end
