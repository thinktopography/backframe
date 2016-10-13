# encoding: utf-8

module Backframe

  class Response

    module Adapter

      class Xlsx

        class << self

          def render(collection, fields)
            filename = SecureRandom.hex(32).to_s.upcase[0,16]
            workbook = WriteXLSX.new(filename)
            worksheet = workbook.add_worksheet
            fields.each_with_index do |field, i|
              worksheet.write_string(0, i, field[:label])
            end
            collection.each_with_index do |item, i|
              fields.each_with_index do |field, j|
                value = Backframe::Record.get_value(item, field[:key])
                worksheet.write_string((i + 1), j, value.to_s)
              end
            end
            workbook.close
            output = open(filename).read
            File.unlink(filename)
            output
          end

        end

      end

    end

  end

end
