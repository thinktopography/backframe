# encoding: utf-8

module Backframe

  class Query

    class << self

      def perform(*args)
        new.perform(*args)
      end

    end

    def perform(params = {})
      records = self.class.name.gsub("Query", "").constantize
      filters = params.except([:exclude_ids,:fields,:page,:per_page,:sort])
      if filters.any?
        records = filter(records, filters)
      end
      if params.key?(:sort)
        sorts = Backframe::Params::Sort.parse(params[:sort])
        records = sort(records, sorts)
      end
      records
    end

    def filter(records, filters)
      records
    end

    def sort(records, sorts)
      order = []
      sorts.each do |sort|
        order << sort[:key] + " " + sort[:order]
      end
      records.order(order.join(", "))
    end

  end

end
