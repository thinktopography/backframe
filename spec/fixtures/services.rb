require 'backframe'

module Backframe

  module Fixtures

    class CreatePostService < Backframe::Service

      def initialize(params)
        @params = params
      end

      def perform
        create_post
        @post
      end

      def create_post
        @post = Post.create(@params)
      end

    end

  end

end
