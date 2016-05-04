require 'backframe/actioncontroller/acts_as_activation'
require 'backframe/actioncontroller/acts_as_api'
require 'backframe/actioncontroller/acts_as_reset'
require 'backframe/actioncontroller/acts_as_resource'
require 'backframe/actioncontroller/acts_as_session'
require 'backframe/activerecord/acts_as_orderable'
require 'backframe/activerecord/acts_as_status'
require 'backframe/activerecord/acts_as_user'
require 'backframe/activerecord/filter_sort'
require 'backframe/activerecord/migration'

module Backframe
  module Exceptions
    class Unauthenticated < StandardError; end
    class Unauthorized < StandardError; end
  end
end

if defined? Rails
  require 'backframe/mime'
  require 'backframe/railtie'
end