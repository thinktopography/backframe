# encoding: utf-8

module Backframe

  class Service

    module Result

      class Failure < Base

        def success?
          false
        end

      end

    end

  end

end
