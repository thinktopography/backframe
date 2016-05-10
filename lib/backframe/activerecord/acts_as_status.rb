# encoding: utf-8

module Backframe
  module ActsAsStatus
    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def acts_as_status(*args)

        field = args[0]
        arguments = args[1]


        if arguments.key?(:required)

          validates_presence_of field

        end

        if arguments.key?(:default)

          after_initialize "init_#{field}_status".to_sym, :if => Proc.new { |d| d.new_record? }

          class_eval <<-EOV
            def init_#{field}_status
              self.#{field} ||= '#{arguments[:default]}'
            end
          EOV

        end

        if arguments.key?(:in)

          validates_inclusion_of field, :in => arguments[:in]

          arguments[:in].each do |status|
            class_eval <<-EOV
              scope :#{status}, -> { where(:status => '#{status}') }

              def #{status}?
                self.#{field} == '#{status}'
              end
            EOV
          end

        end

      end

    end
  end
end