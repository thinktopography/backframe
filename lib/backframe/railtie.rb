# encoding: utf-8

module Backframe
  class Railtie < ::Rails::Railtie
    initializer 'backframe' do |_app|
      require 'backframe/models/activity'
      require 'backframe/models/activation'
      require 'backframe/models/reset'
      require 'backframe/models/story'

      ActionController::Base.send(:include, Backframe::ActsAsAPI)
      ActionController::Base.send(:include, Backframe::ActsAsResource)
      ActionController::Base.send(:include, Backframe::ActsAsActivation)
      ActionController::Base.send(:include, Backframe::ActsAsReset)
      ActionController::Base.send(:include, Backframe::ActsAsSession)
      ActiveRecord::Base.send(:include, Backframe::ActsAsActivable)
      ActiveRecord::Base.send(:include, Backframe::ActsAsDistinct)
      ActiveRecord::Base.send(:include, Backframe::ActsAsEnum)
      ActiveRecord::Base.send(:include, Backframe::ActsAsOrderable)
      ActiveRecord::Base.send(:include, Backframe::ActsAsPercent)
      ActiveRecord::Base.send(:include, Backframe::ActsAsPhone)
      ActiveRecord::Base.send(:include, Backframe::ActsAsUser)
      ActiveRecord::Base.send(:include, Backframe::DefaultValues)
      ActiveRecord::Base.send(:include, Backframe::FilterSort)
      ActiveRecord::Migration.send(:include, Backframe::Migration)
      Backframe::Mime.register_types
    end
  end
end
