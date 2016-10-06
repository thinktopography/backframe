# encoding: utf-8

module Backframe

  class Query

    def self.perform(params = {})
      records = self.name.gsub("Filter", "").constantize
      filters = params.except([:exclude_ids,:fields,:page,:per_page,:sort])
      if filters.any?
        records = self.filter(records, filters)
      end
      if params.key?(:sort)
        sorts = Backframe::Params::Sort.parse(sorts)
        records = self.sort(records, sorts)
      end
      records
    end

    def self.filter(records, filters)
      records
    end

    def self.sort(records, sorts)
      order = []
      sorts.each do |sort|
        order << sort.key + " " + sort.order
      end
      records.order(order.join(", "))
    end

  end

end
