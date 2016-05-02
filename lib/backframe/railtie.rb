module Backframe
  class Railtie < ::Rails::Railtie
    initializer 'backframe' do |_app|
      ActionController::Base.send(:include, Backframe::ActsAsAPI)
      ActionController::Base.send(:include, Backframe::ActsAsResource)
      ActiveRecord::Base.send(:include, Backframe::ActsAsOrderable)
      ActiveRecord::Base.send(:include, Backframe::ActsAsStatus)
      ActiveRecord::Base.send(:include, Backframe::ActsAsUser)
      ActiveRecord::Base.send(:include, Backframe::FilterSort)
      ActiveRecord::Migration.send(:include, Backframe::Migration)
      Backframe::Mime.register_types
    end
  end
end