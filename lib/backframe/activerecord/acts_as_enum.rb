# encoding: utf-8

module Backframe
  module ActsAsEnum
    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def acts_as_enum(*args)

        field = args[0]
        arguments = args[1]

        if arguments.key?(:required)

          validates_presence_of field

        end

        if arguments.key?(:default)

          after_initialize "init_#{field}".to_sym, :if => Proc.new { |d| d.new_record? }

          class_eval <<-EOV
            def init_#{field}
              self.#{field} ||= '#{arguments[:default]}'
            end
          EOV

        end

        if arguments.key?(:in)

          validates_inclusion_of field, :in => arguments[:in]

          class_eval <<-EOV
            scope :#{field}_is, -> (*options) { where('#{field} IN (?)', (options.is_a?(Array) ? options : [options])) }
          EOV

          class_eval <<-EOV
            scope :#{field}_not, -> (*options) { where('#{field} NOT IN (?)', (options.is_a?(Array) ? options : [options])) }
          EOV

          arguments[:in].each do |option|
            class_eval <<-EOV
              scope :#{field}_#{option}, -> { #{field}_is(option) }

              def #{field}_#{option}?
                self.#{field} == '#{option}'
              end

            EOV
          end

        end

      end

    end
  end
end