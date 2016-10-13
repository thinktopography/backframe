require 'backframe'

module Backframe

  module Fixtures

    class ContactQuery < Backframe::Query

      def filter(records, filters)
        records = records.where(first_name: filters[:first_name]) if filters.key?(:first_name)
        records = records.where(last_name: filters[:last_name]) if filters.key?(:last_name)
        records = records.where(email: filters[:email]) if filters.key?(:email)
        records
      end

    end

    class PhotoQuery < Backframe::Query

      def filter(records, filters)
        records
      end

    end

  end

end
