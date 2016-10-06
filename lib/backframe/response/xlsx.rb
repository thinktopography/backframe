# encoding: utf-8

module Backframe

  module Response

    class Xlsx

      class << self

        def ender(collection)
          data = self.format(collection)
          { json: data, content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', status: 200 }
        end

        def format(collection)
          filename = SecureRandom.hex(32).to_s.upcase[0,16]
          workbook = WriteXLSX.new(filename)
          worksheet = workbook.add_worksheet
          # rows = collection_to_array(collection, serializer, fields)
          rows = [['1','2','3'],['4','5','6']]
          rows.each_with_index do |row, i|
            row.each_with_index do |col, j|
              worksheet.write_string(i, j, col)
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
