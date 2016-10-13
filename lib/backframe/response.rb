# encoding: utf-8

module Backframe

  class Response

    class << self

      def index(collection, params = {})
        begin
          template = template(collection)
          fields = Backframe::Params::Fields::parse(template, params[:fields])
          if params[:format] == 'json'
            if params[:page]
              per_page = (params.key?(:per_page)) ? params[:per_page].to_i : 50
              total_records = collection.count
              total_pages = (total_records / per_page.to_f).ceil
              page = [total_pages, params[:page].to_i].min
              offset = per_page * (page - 1)
              total_records = collection.limit(per_page).offset(offset)
              data = Backframe::Adapter::Json.render(collection, fields, total_records, page, total_pages)
            else
              data = Backframe::Adapter::Json.render(collection, fields)
            end
            success(json: data, content_type: 'application/json')
          elsif params[:format] == 'csv'
            data = Backframe::Adapter::Csv.render(collection, fields, ",")
            success(text: data, content_type: 'text/plain')
          elsif params[:format] == 'tsv'
            data = Backframe::Adapter::Csv.render(collection, fields, "\t")
            success(text: data, content_type: 'text/plain')
          elsif params[:format] == 'xml'
            data = Backframe::Adapter::Xml.render(collection, fields)
            success(xml: data, content_type: 'application/xhtml+xml')
          elsif params[:format] == 'xlsx'
            data = Backframe::Adapter::Xml.render(collection, fields)
            success(text: data, content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
          else
            failure('Unknown Format', 404)
          end
        rescue Exception => e
          failure('Application Error', 500)
        end
      end

      def template(collection)
        sample = collection.first
        if sample.is_a?(ActiveRecord::Base)
          ActiveModelSerializers::SerializableResource.new(collection.first).serializable_hash
        elsif sample.is_a?(Hash)
          sample
        end
      end

      def success(*response)
        response[0].merge(status: 200)
      end

      def failure(message, status)
        {
          json: {
            error: {
              message: message,
              status: status
            }
          },
          content_type: 'application/json',
          status: status
        }
      end

    end

  end

end
