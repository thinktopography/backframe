# encoding: utf-8

require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'active_model_serializers'
require 'write_xlsx'

require 'backframe/query'
require 'backframe/query/sort'

require 'backframe/response'
require 'backframe/response/adapter/csv'
require 'backframe/response/adapter/json'
require 'backframe/response/adapter/xlsx'
require 'backframe/response/adapter/xml'
require 'backframe/response/collection'
require 'backframe/response/fields'
require 'backframe/response/record'

require 'backframe/service'
require 'backframe/service/result/base'
require 'backframe/service/result/failure'
require 'backframe/service/result/success'

ActiveModelSerializers.logger = nil

module Backframe
end

if defined? Rails
  require 'backframe/mime'
  require 'backframe/railtie'
end
