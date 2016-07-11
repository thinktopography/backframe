# encoding: utf-8

module Backframe
  module ActsAsDistinct

    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def acts_as_distinct(*args)

        field = args[0]
        arguments = args[1]

        class_eval <<-EOV

          after_initialize :set_default_#{field}, :if => Proc.new { |m| m.new_record? && m.#{arguments[:parent]}.present? }
          after_save :toggle_#{field}_distinction, :if => Proc.new { |m| m.#{arguments[:parent]}.present? && m.#{field} && (m.new_record? || m.#{field}_changed?) }

          scope :#{field.to_s.gsub('is_', '')}, -> { where(:#{field} => true) }

          def #{field.to_s.gsub('is_', '')}?
            return self.#{field}
          end

          private

            def set_default_#{field}
              self.#{field} = self.#{arguments[:parent]}.#{arguments[:association]}.empty?
            end

            def toggle_#{field}_distinction
              self.#{arguments[:parent]}.#{arguments[:association]}.where('id != ?', self.id).each do |item|
                item.update_attributes(:#{field} => false)
              end
            end

        EOV

      end

    end

  end
end