module Backframe
  module FilterSort
    extend ActiveSupport::Concern

    class_methods do
      def filter_query(relation, filters, fields)
        if filters.key?(:q)
          conditions = []
          params = []
          fields.each do |field|
            conditions << "LOWER(#{field}::VARCHAR) LIKE ?"
            params << '%'+filters[:q].downcase+'%'
          end
          args = params.unshift(conditions.join(' OR '))
          relation = relation.where(args)
        end
        relation
      end

      def filter_range(relation, filters, start_date, end_date = nil)
        end_date ||= start_date
        if filters.key?(:start_date) && filters.key?(:end_date)
          relation = relation.where("#{self.table_name}.#{start_date} <= ? AND #{self.table_name}.#{end_date} >= ?", filters[:end_date], filters[:start_date])
        end
        relation
      end

      def filter_boolean(relation, filters, field)
        if filters.key?(field)
          relation = relation.where(:field => true) if filters[field] == 1
          relation = relation.where(:field => false) if filters[field] == 0
        end
        relation
      end

      def sort(relation, key = nil, order = nil)
        self._sort(relation, key, order, 'created_at', 'desc', [self])
      end

      def _sort(relation, key, order, default_key = 'created_at', default_order = 'desc', included = nil)
        sortfields = {}
        included ||= [self]
        included.each do |model|
          model.columns.each do |column|
            sortkey = (model == self) ? column.name : "#{model.table_name.singularize}.#{column.name}"
            sortfields[sortkey] = "\"#{model.table_name}\".\"#{column.name}\""
          end
        end

        key = (key.present? && sortfields.has_key?(key)) ? key : default_key
        order = (order.present?) ? order : default_order
        relation.order("#{sortfields[key]} #{order}")
      end
    end
  end
end