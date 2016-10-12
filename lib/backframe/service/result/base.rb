# encoding: utf-8

module Backframe

  class Service

    module Result

      class Base

        def initialize(*args)
          args[0].each do |key, val|
            self.class.send(:attr_accessor, key)
            self.instance_variable_set("@#{key}", val)
          end
        end

      end

    end

  end

end
