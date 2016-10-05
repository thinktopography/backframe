# encoding: utf-8

module Backframe

  module Response

    class Base

      def self.index(collection, format)
        json = collection.to_json
        if format == 'json'
          Backframe::Response::Json.render(json)
        elsif format == 'csv'
          Backframe::Response::Csv.render(json, ",")
        elsif format == 'tsv'
          Backframe::Response::Csv.render(json, "\t")
        elsif format == 'xml'
          Backframe::Response::Xml.render(json)
        elsif format == 'xlsx'
          Backframe::Response::Xlsx.render(json)
        else
          Backframe::Response::Error.render(json)
        end
      end

    end

  end

end
