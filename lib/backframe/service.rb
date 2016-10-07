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
            # errors = e.errors
            service.before_rollback
            raise ActiveRecord::Rollback
          end
          service.before_commit
        end

        if message.nil?
          service.after_commit
        else
          service.after_rollback
        end

        return (message.present?) ? Result::Failure.new(message: message, errors: errors) : result
      end

    end

    def perform
    end

    def before_rollback
    end

    def after_rollback
    end

    def before_commit
    end

    def after_commit
    end

  end

end
