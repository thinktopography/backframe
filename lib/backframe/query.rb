# encoding: utf-8

module Backframe

  class Query

    EXCLUDE_IDS_REGEX = /^[\d,]*$/
    SORT_REGEX = /^[\w\_\-,]*$/

    class << self

      def perform(*args)
        new.perform(*args)
      end

    end

    def perform(records, params = {})
      filters = params.except([:exclude_ids,:fields,:page,:per_page,:sort])
      if filters.any?
        records = filter(records, filters)
      end
      if params.key?(:exclude_ids) && params[:exclude_ids] =~ EXCLUDE_IDS_REGEX
        table = records.arel_table.name
        records = records.where('"'+table+'"."id" NOT IN (?)', params[:exclude_ids].split(","))
      end
      if params.key?(:sort) && params[:sort] =~ SORT_REGEX
        sorts = Backframe::Query::Sort.parse(params[:sort])
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
        order << sort[:key] + " " + sort[:order]
      end
      records.order(order.join(", "))
    end

  end

end
