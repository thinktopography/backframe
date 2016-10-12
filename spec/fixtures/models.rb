require 'active_record'

module Backframe

  module Fixtures

    class Post < ActiveRecord::Base

      has_many :comments
      belongs_to :author

      validates :title, presence: true
      validates :author, presence: true

    end

    class Comment < ActiveRecord::Base

      belongs_to :post
      belongs_to :author

    end

    class Author < ActiveRecord::Base

      has_many :posts

    end

  end

end
