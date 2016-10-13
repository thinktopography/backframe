# encoding: utf-8

module Backframe

  class Response

    class Record

      class << self

        def get_value(record, path)
          path = cast_path(path)
          index = 0
          length = path.length
          while record != nil && index < length
            record = record.with_indifferent_access[path[index]]
            index += 1
          end
          record
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

      end

    end

  end

end
