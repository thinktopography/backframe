# encoding: utf-8

module Backframe
  module ActsAsPercent

    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def acts_as_percent(entity)

        class_eval <<-EOV

          after_initialize :uncast_percent_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }
          before_save :cast_percent_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }
          after_save :uncast_percent_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }

          def raw_#{entity}
            self.#{entity} / 100.00
          end

          private

          def uncast_percent_#{entity}
            self.#{entity} = self.#{entity} * 100.00
          end

          def cast_percent_#{entity}
            self.#{entity} = self.#{entity} / 100.00
          end

        EOV

      end

    end

  end
end



