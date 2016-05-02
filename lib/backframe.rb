require 'backframe/mime'
require 'backframe/acts_as_resource'
require 'backframe/filter_sort'
require 'backframe/acts_as_orderable'
require 'backframe/acts_as_api'
require 'backframe/acts_as_resource'
require 'backframe/acts_as_status'
require 'backframe/acts_as_user'
require 'backframe/migration'
require 'write_xlsx'

module Backframe
  module Exceptions
    class Unauthenticated < StandardError; end
    class Unauthorized < StandardError; end
  end
end

if defined? Rails
  require 'backframe/railtie'
end