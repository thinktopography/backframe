# encoding: utf-8

require 'phony'

module Backframe
  module ActsAsPhone

    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def acts_as_phone(entity)

        class_eval <<-EOV

          after_initialize :uncast_phone_#{entity}, :if => Proc.new { |c| !c.new_record? && c.#{entity}.present? }
          before_save :cast_phone_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }
          after_save :uncast_phone_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }

          validate :validates_phone_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }

          private

          def uncast_phone_#{entity}
            self.#{entity} = self.#{entity}[0]+'-'+self.#{entity}[1,3]+'-'+self.#{entity}[4,3]+'-'+self.#{entity}[7,4]
          end

          def cast_phone_#{entity}
            self.#{entity} = #{entity}_to_international(self.#{entity})
          end

          def validates_phone_#{entity}
            testvalue = #{entity}_to_international(self.#{entity})
            if !Phony.plausible?(testvalue)
              self.errors.add(:#{entity}, 'invalid #{entity} number')
            end
          end

          def #{entity}_to_international(value)
            newvalue = value.gsub('(', '').gsub(')', '').gsub('.', '').gsub('-', '').gsub(' ', '')
            newvalue = (newvalue.length == 10) ? '1'+value : value
            Phony.normalize(newvalue)
          end

        EOV

      end

    end

  end
end



