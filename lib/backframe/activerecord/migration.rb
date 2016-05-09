module Backframe
  module Migration
    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def add_foreign_key_index(from, to, column)
        add_foreign_key(from, to, :column => column)
        add_index(from, column)
      end

      def remove_foreign_key_index(from, column)
        add_index(from, column)
        add_foreign_key(from, :column => column)
      end

    end
  end
end
