# encoding: utf-8

module Backframe

  module Params
    
    class Fields

      class << self

        def parse(hash, field_string = nil)
          keys = Backframe::Record.keys(hash)
          fields = []
          if field_string.nil?
            keys.each do |key|
              fields << { label: key, key: key }
            end
          else
            field_string.split(",").each do |token|
              field = nil
              if token =~ /([\w\s]*):([\w\s]*)/
                field = { label: $1.strip, key: $2.strip }
              elsif token =~ /([\w\s]*)/
                field = { label: $1.strip, key: $1.strip }
              end
              if keys.include?(field[:key])
                fields << field
              end
            end
          end
          fields
        end

      end

    end

  end

end
