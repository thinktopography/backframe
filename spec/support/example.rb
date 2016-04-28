class Example < ActiveRecord::Base
  def self.sort(relation, key = nil, order = nil)
    self._sort(relation, key, order, 'created_at', 'desc', [self])
  end

  def self._sort(relation, key, order, default_key = 'created_at', default_order = 'desc', included = nil)
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
