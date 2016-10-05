# encoding: utf-8

module Backframe

  class Filter

    def self.perform(params = {})
      params[:per_page] ||= 2
      model = self.name.gsub("Filter", "").constantize
      records = model
      if params.key?(:criteria)
        criteria = JSON.parse(filters[:criteria])
        fields = model.fields
        array = Criteria.parse(criteria, fields)
        records = records.where(array)
      end
      filters = params.except([:criteria,:sort,:page,:per_page,:fields,:exclude_ids])
      if filters.any?
        records = self.filter(records, filters)
      end
      if params.key?(:sort)
        records = self.sort(records, params[:sort])
      end
      if params.key?(:page)
        records = self.page(records, params[:page], params[:per_page])
      else
        records = records.all
      end
      records
    end

    def self.sort(records, sorts)
      sorts.split(',').each do |sort|
        key = (sort[0] == '-') ? sort[1..-1] : sort
        order = (sort[0] == '-') ? 'desc' : 'asc'
        records = records.order(key+" "+order)
      end
      records
    end

    def self.page(records, page, per_page)
      offset = (page.to_i - 1) * per_page.to_i
      records.limit(per_page).offset(offset)
    end

  end

end
