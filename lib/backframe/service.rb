# encoding: utf-8

module Backframe

  class Service

    class << self

      def build(*args)
        new(*args)
      end

      def perform
        service = build(*args)

        message = nil
        result = nil

        ActiveRecord::Base.transaction do
          begin
            result = service.perform
          rescue StandardError => e
            message = e.message
            raise ActiveRecord::Rollback
          end
        end

        return (message.present?) ? Result::Failure.new(message: message) : result
      end

    end

    def perform
    end

  end

end
