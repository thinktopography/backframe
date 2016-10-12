require 'active_model_serializers'

module Backframe

  module Fixtures

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
  
end
