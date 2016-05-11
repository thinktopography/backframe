# encoding: utf-8

module Backframe
  class Railtie < ::Rails::Railtie
    initializer 'backframe' do |_app|
      ActionController::Base.send(:include, Backframe::ActsAsAPI)
      ActionController::Base.send(:include, Backframe::ActsAsResource)
      ActionController::Base.send(:include, Backframe::ActsAsActivation)
      ActionController::Base.send(:include, Backframe::ActsAsReset)
      ActionController::Base.send(:include, Backframe::ActsAsSession)
      ActiveRecord::Base.send(:include, Backframe::ActsAsActivable)
      ActiveRecord::Base.send(:include, Backframe::ActsAsDistinct)
      ActiveRecord::Base.send(:include, Backframe::ActsAsEnum)
      ActiveRecord::Base.send(:include, Backframe::ActsAsOrderable)
      ActiveRecord::Base.send(:include, Backframe::ActsAsUser)
      ActiveRecord::Base.send(:include, Backframe::FilterSort)
      ActiveRecord::Migration.send(:include, Backframe::Migration)
      Backframe::Mime.register_types
    end
  end
end