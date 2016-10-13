# encoding: utf-8

module Backframe

  class Response

    class Collection

      def initialize(collection, page, per_page)
        @collection = collection
        @page = page
        @per_page = per_page
      end

      def total_records
        @collection.count
      end

      def total_pages
        @page ? (total_records / @per_page.to_f).ceil : 1
      end

      def current_page
        @page ? [total_pages, @page.to_i].min : 1
      end

      def limit
        @page ? @per_page : total_records
      end

      def offset
        @page ? limit * (@page - 1) : 0
      end

      def records
        @page ? @collection.limit(limit).offset(offset) : @collection.all
      end

    end

  end

end
