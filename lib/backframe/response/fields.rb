# encoding: utf-8

module Backframe

  class Response

    class Fields

      def initialize(collection, fields)
        @collection = collection
        @fields = fields
      end

      def any?
        !@fields.nil?
      end

      def array
        return @array if defined?(@array)
        hash = ActiveModelSerializers::SerializableResource.new(@collection.first).serializable_hash
        keys = keys(hash)
        @array = []
        if @fields.nil?
          keys.each do |key|
            @array << { label: key, key: key }
          end
        else
          @fields.split(",").each do |token|
            field = nil
            if token =~ /([\w\s]*):([\w\s\.]*)/
              field = { label: $1.strip, key: $2.strip }
            elsif token =~ /([\w\s\.]*)/
              field = { label: $1.strip, key: $1.strip }
            end
            if keys.include?(field[:key])
              @array << field
            end
          end
        end
        @array
      end

      private

      def keys(hash, prefix = '')
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

    end

  end

end
