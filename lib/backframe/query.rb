# encoding: utf-8

module Backframe

  class Query

    class << self

      def build(*args)
        new(*args)
      end

      def perform
        build(*args).perform
      end

    end

    def perform(params = {})
      records = self.name.gsub("Filter", "").constantize
      filters = params.except([:exclude_ids,:fields,:page,:per_page,:sort])
      if filters.any?
        records = filter(records, filters)
      end
      if params.key?(:sort)
        sorts = Backframe::Params::Sort.parse(sorts)
        records = sort(records, sorts)
      end
      records
    end

    def filter(records, _filters)
      records
    end

    def sort(records, sorts)
      order = []
      sorts.each do |sort|
        order << sort.key + " " + sort.order
      end
      records.order(order.join(", "))
    end

  end

end
