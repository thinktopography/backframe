# encoding: utf-8

module Backframe

  module Response

    class Csv

      def self.render(collection, attributes = 'ALL', separator = ",")
        keys = self.keys(collection, attributes)
        data = self.format(collection, keys, separator)
        { text: data, content_type: 'text/plain', status: 200 }
      end

      def self.keys(collection, attributes)
        if attributes == 'ALL'
          self._flatten_hash_keys(collection.first, prefix = '')
        else
          attributes
        end
      end

      def self.format(collection, keys, separator)
        records = []
        records << keys.join(separator)
        collection.each do |item|
          records << keys.map { |key| self._get_hash_value(item, key) }.join(separator)
        end
        records.join("\n")
      end

      def self._flatten_hash_keys(hash, prefix = '')
        keys = []
        hash.each do |key, value|
          fullkey =  (!prefix.empty?) ? "#{prefix}.#{key}" : key
          if value.is_a?(Hash)
            keys.concat(self._flatten_hash_keys(value, fullkey))
          else
            keys << fullkey.to_s
          end
        end
        keys
      end

      def self._get_hash_value(hash, key)
        parts = key.is_a?(Array) ? key : key.to_s.split(".")
        part = parts.shift
        value = hash.with_indifferent_access[part]
        value.is_a?(Hash) ? self._get_hash_value(value, parts) : value
     end

   end

  end

end
