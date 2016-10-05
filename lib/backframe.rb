# encoding: utf-8

require 'active_support'
require 'active_support/core_ext'
require 'write_xlsx'

require 'backframe/version'

module Backframe
  require 'backframe/criteria'
  require 'backframe/response'
  require 'backframe/service'
end

if defined? Rails
  require 'backframe/mime'
  require 'backframe/railtie'
end
