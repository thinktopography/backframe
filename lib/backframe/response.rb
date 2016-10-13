# encoding: utf-8

module Backframe

  class Response

    FIELDS_REGEX = /^[A-Za-z0-9\_,]*$/
    PAGE_REGEX = /^[0-9]*$/

    class << self

      def render(records, params = {})
        # begin
          fields = Backframe::Response::Fields.new(records, params[:fields])
          collection = Backframe::Response::Collection.new(records, params[:page], params[:per_page])
          if params[:format] == 'json'
            data = Backframe::Response::Adapter::Json.render(collection, fields)
            success(json: data, content_type: 'application/json')
          elsif params[:format] == 'xml'
            data = Backframe::Response::Adapter::Xml.render(collection, fields)
            success(xml: data, content_type: 'application/xhtml+xml')
          elsif params[:format] == 'csv'
            data = Backframe::Response::Adapter::Csv.render(collection, fields, ",")
            success(text: data, content_type: 'text/plain')
          elsif params[:format] == 'tsv'
            data = Backframe::Response::Adapter::Csv.render(collection, fields, "\t")
            success(text: data, content_type: 'text/plain')
          elsif params[:format] == 'xlsx'
            data = Backframe::Response::Adapter::Xlsx.render(collection, fields)
            success(text: data, content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
          else
            failure('Unknown Format', 404)
          end
        # rescue Exception => e
        #   failure('Application Error', 500)
        # end
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
