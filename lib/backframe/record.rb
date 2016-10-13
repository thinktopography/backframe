# encoding: utf-8

module Backframe

  class Record

    class << self

      def get_value(record, path)
        hash = serialized(record)
        path = cast_path(path)
        index = 0
        length = path.length
        while hash != nil && index < length
          hash = hash.with_indifferent_access[path[index]]
          index += 1
        end
        hash
      end

      def keys(record, prefix = '')
        hash = serialized(record)
        keys = []
        hash.each do |key, value|
          fullkey =  (!prefix.empty?) ? "#{prefix}.#{key}" : key
          if value.is_a?(Hash)
            keys.concat(keys(value, fullkey))
          else
            keys << fullkey.to_s
          end
        end
        keys
      end

      def has_key(hash, path)
        keys(hash).include?(path)
      end

      def cast_path(path)
        if path.is_a?(String)
          path.split(".")
        elsif path.is_a?(Symbol)
          path.to_s.split(".")
        elsif path.is_a?(Array)
          path
        end
      end

      def serialized(record)
        if record.is_a?(ActiveRecord::Base)
          ActiveModelSerializers::SerializableResource.new(record).serializable_hash
        else
          record
        end
      end

    end

  end

end
