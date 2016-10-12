require 'active_record'
require 'active_model_serializers'
require 'backframe'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  self.verbose = false
  create_table :posts, force: true do |t|
    t.string :title
    t.text :body
    t.references :author
    t.timestamps null: false
  end
  create_table :authors, force: true do |t|
    t.string :name
    t.timestamps null: false
  end
  create_table :comments, force: true do |t|
    t.text :contents
    t.references :author
    t.references :post
    t.timestamp null: false
  end
end

module ARModels

  class Post < ActiveRecord::Base
    has_many :comments
    belongs_to :author
  end

  class Comment < ActiveRecord::Base
    belongs_to :post
    belongs_to :author
  end

  class Author < ActiveRecord::Base
    has_many :posts
  end

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

  class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :body

    has_many :comments
    belongs_to :author
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :contents

    belongs_to :author
  end

  class AuthorSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :posts
  end

end
