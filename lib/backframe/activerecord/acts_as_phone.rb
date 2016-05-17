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

          after_initialize :extract_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }
          before_save :compress_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }

          validate :validates_#{entity}, :if => Proc.new { |c| c.#{entity}.present? }
          private

          def extract_#{entity}
            self.#{entity} = Phony.format(self.#{entity}, :format => '%{ndc}-%{local}')
          end

          def compress_#{entity}
            self.#{entity} = Phony.normalize(self.#{entity})
            self.#{entity} = '1'+self.#{entity} if (self.#{entity}.length == 10)
          end

          def validates_#{entity}
            testvalue = Phony.normalize(self.#{entity})
            testvalue = '1'+test if (testvalue.length == 10)
            if Phony.plausible?(testvalue)
              self.#{entity}.add(:#{entity}, 'invalid #{entity} number')
            end
          end

        EOV

      end

    end

  end
end



