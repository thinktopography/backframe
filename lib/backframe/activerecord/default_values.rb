# encoding: utf-8

module Backframe
  module DefaultValues
    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def default_values(*args)

        arguments = args[0] || {}

        after_initialize :set_default_values, :if => Proc.new { |o| o.new_record? }

        class_eval <<-EOV

          def set_default_values
            self.attributes = #{arguments.symbolize_keys.to_s}
          end

        EOV


      end

    end
  end
end