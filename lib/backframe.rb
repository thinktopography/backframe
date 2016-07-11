# encoding: utf-8

require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'
require 'liquid'

require 'backframe/actioncontroller/acts_as_activation'
require 'backframe/actioncontroller/acts_as_api'
require 'backframe/actioncontroller/acts_as_reset'
require 'backframe/actioncontroller/acts_as_resource'
require 'backframe/actioncontroller/acts_as_session'
require 'backframe/activerecord/acts_as_activable'
require 'backframe/activerecord/acts_as_distinct'
require 'backframe/activerecord/acts_as_enum'
require 'backframe/activerecord/acts_as_orderable'
require 'backframe/activerecord/acts_as_percent'
require 'backframe/activerecord/acts_as_phone'
require 'backframe/activerecord/acts_as_user'
require 'backframe/activerecord/default_values'
require 'backframe/activerecord/filter_sort'
require 'backframe/activerecord/migration'
require 'backframe/models/activity'
require 'backframe/models/activation'
require 'backframe/models/reset'
require 'backframe/models/story'
require 'backframe/serializers/activity_serializer'
require 'backframe/image_cache/image_cache'

module Backframe

  extend ActiveSupport::Autoload

  autoload :Activity
  autoload :Activation
  autoload :Reset

  module Exceptions
    class Unauthenticated < StandardError; end
    class Unauthorized < StandardError; end
  end

end
if defined? Rails
  require 'backframe/mime'
  require 'backframe/railtie'
end
