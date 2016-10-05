# encoding: utf-8

require 'active_support'
require 'active_support/core_ext'
require 'write_xlsx'

require 'backframe/response/csv'
require 'backframe/response/error'
require 'backframe/response/json'
require 'backframe/response/xlsx'
require 'backframe/response/xml'
require 'backframe/criteria'
require 'backframe/filter'
require 'backframe/response'
require 'backframe/service'

module Backframe

  extend ActiveSupport::Autoload

end

if defined? Rails
  require 'backframe/mime'
  require 'backframe/railtie'
end
