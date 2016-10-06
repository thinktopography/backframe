# encoding: utf-8

module Backframe

  module Response

    class Base

      class << self

        def index(collection, fields = nil, format = 'json')
          fields = Backframe::Params::Fields::parse(collection.first, fields)
          if format == 'json'
            Backframe::Response::Json.render(collection, fields)
          elsif format == 'csv'
            Backframe::Response::Csv.render(collection, fields, ",")
          elsif format == 'tsv'
            Backframe::Response::Csv.render(collection, fields, "\t")
          elsif format == 'xml'
            Backframe::Response::Xml.render(collection, fields)
          elsif format == 'xlsx'
            Backframe::Response::Xlsx.render(collection, fields)
          else
            Backframe::Response::Error.render(collection)
          end
        end

      end

    end

  end

end
