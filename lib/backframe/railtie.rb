# encoding: utf-8

module Backframe
  class Railtie < ::Rails::Railtie
    initializer 'backframe' do |_app|
      Backframe::Mime.register_types
    end
  end
end
