# encoding: utf-8

module Backframe

  class Response

    class << self

      def index(collection, fields = nil, format = 'json')
        template = ActiveModelSerializers::SerializableResource.new(collection.klass.new).serializable_hash
        fields = Backframe::Params::Fields::parse(template, fields)
        if format == 'json'
          Backframe::Adapter::Json.render(collection, fields)
        elsif format == 'csv'
          Backframe::Adapter::Csv.render(collection, fields, ",")
        elsif format == 'tsv'
          Backframe::Adapter::Csv.render(collection, fields, "\t")
        elsif format == 'xml'
          Backframe::Adapter::Xml.render(collection, fields)
        elsif format == 'xlsx'
          Backframe::Adapter::Xlsx.render(collection, fields)
        else
          { text: 'Unknown format', content_type: 'text/plain', status: 404 }
        end
      end

    end

  end

end
