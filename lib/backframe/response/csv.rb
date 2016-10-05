# encoding: utf-8

module Backframe

  module Response

    class Csv

      def self.render(collection, separator)
        data = self.format(collection, separator)
        { text: data, content_type: 'text/plain', status: 200 }
      end

      def self.format(collection, separator)
        output = []
        # rows = collection_to_array(collection, serializer, fields)
        rows = [['1','2','3'],['4','5','6']]
        rows.each do |row|
          output << row.join(separator)
        end
        output.join("\n")
      end

    end

  end

end
