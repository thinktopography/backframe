require 'backframe'

module Backframe

  module Fixtures

    class CreateContactService < Backframe::Service

      def initialize(params)
        @params = params
      end

      def perform
        create_contact
        { contact: @contact }
      end

      def create_contact
        @contact = Contact.create!(@params)
      end

    end

  end

end
