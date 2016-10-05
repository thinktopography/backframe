# encoding: utf-8

module Backframe

  module Response

    class Base

      def self.index(collection, format)
        if format == 'json'
          Backframe::Response::Json.render(collection)
        elsif format == 'csv'
          Backframe::Response::Csv.render(collection, ",")
        elsif format == 'tsv'
          Backframe::Response::Csv.render(collection, "\t")
        elsif format == 'xml'
          Backframe::Response::Xml.render(collection)
        elsif format == 'xlsx'
          Backframe::Response::Xlsx.render(collection)
        else
          Backframe::Response::Error.render(collection)
        end
      end

    end

  end

end
