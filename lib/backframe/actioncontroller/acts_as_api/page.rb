# encoding: utf-8

module Backframe
  module ActsAsAPI
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

        collection = (params[:format] == 'json') ? collection.page(args[:page]).per(args[:per_page]) : collection.all

        respond_to do |format|
          format.json {
            fields = (args.key?(:fields)) ? args[:fields].split(',').map(&:to_sym) : serializer._attributes
            render json: collection,
                   each_serializer: serializer,
                   content_type: 'application/json',
                   adapter: Backframe::ActsAsAPI::Adapter,
                   fields: fields,
                   links: pagination_links(collection, args[:per_page], args[:page]),
                   status: 200
          }
          format.csv {
            fields = expand_fields(collection, serializer,  args[:fields])
            content_type = (args.key?(:download) && args[:download] == 'false') ? 'text/plain' : 'text/csv'
            render :text => collection_to_csv(collection, serializer, fields, ","), :content_type => content_type, :status => 200
          }
          format.tsv {
            fields = expand_fields(collection, serializer,  args[:fields])
            content_type = (args.key?(:download) && args[:download] == 'false') ? 'text/plain' : 'text/tab-separated-values'
            render :text => collection_to_csv(collection, serializer, fields, "\t"), :content_type => content_type, :status => 200
          }
          format.xlsx {
            fields = expand_fields(collection, serializer,  args[:fields])
            render :text => collection_to_xls(collection, serializer, fields), :content_type => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :status => 200
          }
        end
      end

      def expand_fields(collection, serializer, fields)
        if fields.present?
          fields.split(',').map(&:to_s)
        else
          serialized = serializer.new(collection.first).attributes
          flatten_hash_keys(serialized)
        end
      end

      def flatten_hash_keys(hash, prefix = '')
        keys = []
        hash.each do |key, value|
          fullkey =  (!prefix.empty?) ? "#{prefix}.#{key}" : key
          if value.is_a?(Hash)
            keys.concat(flatten_hash_keys(value, fullkey))
          else
            keys << fullkey.to_s
          end
        end
        keys
      end

      def collection_to_array(collection, serializer, fields)
        rows = []
        cols = []
        row = []
        fields.each do |key|
          row << key
        end
        rows << row
        collection.all.each do |record|
          row = []
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
            elsif value.is_a?(NilClass)
              value = ''
            end
            row << "#{value}"
          end
          rows << row
        end
        rows
      end

      def collection_to_csv(collection, serializer, fields, separator)
        output = []
        rows = collection_to_array(collection, serializer, fields)
        rows.each do |row|
          output << row.join(separator)
        end
        output.join("\n")
      end

      def collection_to_xls(collection, serializer, fields)
        filename = SecureRandom.hex(32).to_s.upcase[0,16]
        workbook = WriteXLSX.new(filename)
        worksheet = workbook.add_worksheet
        rows = collection_to_array(collection, serializer, fields)
        rows.each_with_index do |row, i|
          row.each_with_index do |col, j|
            worksheet.write(i, j, col)
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
