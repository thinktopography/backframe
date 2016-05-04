module Backframe
  module Migration
    extend ActiveSupport::Concern

    class_methods do

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
