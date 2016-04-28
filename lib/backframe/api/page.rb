module Backframe
  module API
    module Page
      DEFAULT_PAGE = 1
      DEFAULT_PER_PAGE = 100

      def page(collection, serializer = nil)
        classname = collection.base_class.name+'Serializer'
        serializer ||= classname.constantize
        args = params.except(*request.path_parameters.keys)
        filters = args.except([:sort,:page,:per_page,:fields,:exclude_ids])
        model = (collection.respond_to?(:klass)) ? collection.klass.name.constantize : collection
        collection = model.filter(collection, filters) if collection.respond_to?(:filter)

        if args.key?(:sort)
          args[:sort].split(',').each do |sort|
            key = (sort[0] == '-') ? sort[1..-1] : sort
            order = (sort[0] == '-') ? 'desc' : 'asc'
            collection = model.sort(collection, key, order)
          end
        else
          collection = model.sort(collection)
        end

        if args.key?(:exclude_ids)
          ids = args[:exclude_ids].split(',')
          collection = collection.where('id NOT IN (?)', ids)
        end

        if args.key?(:all)
          args[:page] = 1
          args[:per_page] = 10000
        end

        args[:page] ||= DEFAULT_PAGE
        args[:per_page] ||= DEFAULT_PER_PAGE


        collection = collection.page(args[:page]).per(args[:per_page])
        fields = (args.key?(:fields)) ? args[:fields].split(',').map(&:to_sym) : serializer._attributes

        respond_to do |format|
          format.json {
            render json: collection,
                   content_type: 'application/json',
                   adapter: Backframe::API::Adapter,
                   fields: fields,
                   links: pagination_links(collection, args[:per_page], args[:page])
          }
          format.csv {
            content_type = (args.key?(:plain)) ? 'text/plain' : 'text/csv'
            render :text => collection_to_csv(collection, serializer, fields, ","), :content_type => content_type, :status => 200
          }
          format.tsv {
            content_type = (args.key?(:plain)) ? 'text/plain' : 'text/tab-separated-values'
            render :text => collection_to_csv(collection, serializer, fields, "\t"), :content_type => content_type, :status => 200
          }
          format.xls {
            content_type = (args.key?(:plain)) ? 'text/xml' : 'application/xls'
            render :text => collection_to_xls(collection, serializer, fields), :content_type => content_type, :status => 200
          }
          format.xlsx {
            content_type = (args.key?(:plain)) ? 'text/xml' : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            render :text => collection_to_xls(collection, serializer, fields), :content_type => content_type, :status => 200
          }
        end
      end

      def collection_to_csv(collection, serializer, fields, separator)
        rows = []
        line = []
        headers = []
        collection.each do |record|
          headers = []
          line = []
          serialized = OpenStruct.new(ActiveModel::SerializableResource.new(record).as_json)
          fields.each do |fullkey|
            value = serialized
            fullkey.to_s.split(".").each do |key|
              if value.respond_to?(key)
                value = value.send(key)
                if value.is_a?(Time)
                  value = value.strftime("%F %T")
                elsif value.is_a?(Date)
                  value = value.strftime("%F")
                elsif value.is_a?(Hash)
                  value = OpenStruct.new(value)
                else
                  value = value.to_s
                end
              else
                value = nil
              end
            end
            if !value.is_a?(OpenStruct)
              headers << fullkey
              line << value
            end
          end
          rows << line.join(separator)
        end
        rows.unshift(headers.join(separator))
        rows.join("\n")
      end

      def collection_to_xls(collection, serializer, fields)
        filename = SecureRandom.hex(32).to_s.upcase[0,16]
        workbook = WriteXLSX.new(filename)
        worksheet = workbook.add_worksheet
        row = 0
        col = 0
        fields.each_with_index do |key, col|
          worksheet.write(row, col, key)
        end
        collection.all.each_with_index do |record, index|
          row = index + 1
          serialized = serializer.new(record).attributes
          fields.each_with_index do |fullkey, col|
            value = serialized
            fullkey.to_s.split(".").each do |key|
              key = key.to_sym
              if value.is_a?(Hash) && value.key?(key)
                value = value[key]
              else
                value = nil
              end
            end
            if value.is_a?(Time)
              value = value.strftime("%F %T")
            elsif value.is_a?(Date)
              value = value.strftime("%F")
            elsif value.is_a?(TrueClass)
              value = 'true'
            elsif value.is_a?(FalseClass)
              value = 'false'
            end
            value = (!value.is_a?(String)) ? '' : value
            worksheet.write(row, col, value)
          end
        end
        workbook.close
        data = open(filename).read
        File.unlink(filename)
        data
      end

      def pagination_links(collection, per_page, page)
        return {} if collection.total_count.zero?
        links = {}
        links[:self] = pagination_link(per_page, page)
        if collection.next_page.present?
          links[:next] = pagination_link(per_page, collection.next_page)
        end
        if page.to_i < collection.total_pages
          links[:last] = pagination_link(per_page, collection.total_pages)
        end
        if page.to_i > 1
          links[:first] = pagination_link(per_page, 1)
        end
        if collection.prev_page.present?
          links[:prev] = pagination_link(per_page, collection.prev_page)
        end
        links
      end

      def pagination_link(per_page, page)
        args = (per_page.to_i != DEFAULT_PER_PAGE) ? "per_page="+per_page.to_s+"&page="+page.to_s : "page="+page.to_s
        base_api_url+request.path+"?"+args
      end
    end
  end
end
