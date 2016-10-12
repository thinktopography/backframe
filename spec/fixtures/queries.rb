require 'backframe'

module Backframe

  module Fixtures

    class PostQuery < Backframe::Query

      def filter(records, filters)
        records = records.where(title: filters[:title]) if filters.key?(:title)
        records = records.where(author_id: filters[:author_id]) if filters.key?(:author_id)
        records
      end

    end

    class AuthorQuery < Backframe::Query

      def filter(records, filters)
        records
      end

    end

    class CommentQuery < Backframe::Query

      def filter(records, filters)
        records
      end

    end

  end

end
