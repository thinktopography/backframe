module Backframe
  module API
    class Adapter < ActiveModel::Serializer::Adapter::Attributes
      attr_reader :fields, :links

      def initialize(serializer, options = {})
        super
        @fields = options[:fields]
        @links = options[:links]
      end

      def serializable_hash(options = nil)
        if paginated?
          with_pagination_metadata(super)
        else
          select_fields(super)
        end
      end

      def paginated?
        serializer.respond_to?(:paginated?) && serializer.paginated?
      end

      private

      def with_pagination_metadata(records)
        {
          records: records.map(&method(:select_fields)),
          total_records: paginated.total_count,
          total_pages: paginated.total_pages,
          current_page: paginated.current_page,
          links: links
        }
      end

      def paginated
        serializer.object
      end

      def select_fields(object)
        if fields.present?
          object.select { |key, val| fields.include?(key) }
        else
          object
        end
      end
    end
  end
end
