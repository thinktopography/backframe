# encoding: utf-8

require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'active_model_serializers'
require 'write_xlsx'

require 'backframe/adapter/csv'
require 'backframe/adapter/json'
require 'backframe/adapter/xlsx'
require 'backframe/adapter/xml'
require 'backframe/params/fields'
require 'backframe/params/sort'
require 'backframe/service/result/base'
require 'backframe/service/result/failure'
require 'backframe/service/result/success'
require 'backframe/query'
require 'backframe/record'
require 'backframe/response'
require 'backframe/service'

ActiveModelSerializers.logger = nil

module Backframe
end

if defined? Rails
  require 'backframe/mime'
  require 'backframe/railtie'
end
