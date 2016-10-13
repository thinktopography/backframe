require 'active_model_serializers'

module Backframe

  module Fixtures

    class ContactSerializer < ActiveModel::Serializer

      attributes :id, :first_name, :last_name, :email

      belongs_to :photo

    end

    class PhotoSerializer < ActiveModel::Serializer

      attributes :id, :path

    end

  end

end
