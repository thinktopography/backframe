# encoding: utf-8

module Backframe

  class Criteria

    def self.parse(criteria, fields)
      fieldmap = map(fields)
      where, values = clauses(criteria, fieldmap)
      values.unshift(where)
    end

    def self.map(fields)
      map = {}
      fields.each do |field|
        field.stringify_keys!
        map[field['code'].to_s] = field['data_type']
      end
      map
    end

    def self.clauses(object, fieldmap)
      if object.key?('and')
        clause(object, 'and', fieldmap)
      elsif object.key?('or')
        clause(object, 'or', fieldmap)
      else
        condition(object, fieldmap)
      end
    end

    def self.clause(object, conjunction, fieldmap)
      clause = []
      values = []
      object[conjunction].each do |argument|
        condition, value = clauses(argument, fieldmap)
        clause << condition
        values = values + value
      end
      return '('+clause.join(' '+conjunction.upcase+' ')+')', values
    end

    def self.condition(object, fieldmap)
      key = object['key']
      value = object['val']
      data_type = fieldmap[key]
      if data_type == 'integer'
        key = '(data->>\''+object['key']+'\')::INT'
        value = value.to_i
      elsif data_type == 'date'
        key = '(data->>\''+object['key']+'\')::DATE'
        value = value
      elsif data_type == 'array'
        key = 'data->\''+object['key']+'\''
        value = '"'+value+'"'
      else
        key = 'data->>\''+object['key']+'\''
      end
      if object['op'] == 'eq'
        return key+' = ?', [value]
      elsif object['op'] == 'neq'
        return key+' = ?', [value]
      elsif object['op'] == 'lik'
        return 'LOWER('+key+') LIKE ?', ['%'+value.downcase+'%']
      elsif object['op'] == 'lt'
        return key+' < ?', [value]
      elsif object['op'] == 'lte'
        return key+' <= ?', [value]
      elsif object['op'] == 'gt'
        return key+' > ?', [value]
      elsif object['op'] == 'gte'
        return key+' >= ?', [value]
      elsif object['op'] == 'btw'
        return key+' BETWEEN ? AND ?', value
      elsif object['op'] == 'in'
        return key+' IN (?)', [value]
      elsif object['op'] == 'nin'
        return key+' NOT IN (?)', [value]
      elsif object['op'] == 'hs'
        return key+' @> ?', [value]
      elsif object['op'] == 'nhs'
        return key+' @> ?', [value]
      end
    end

  end

end
