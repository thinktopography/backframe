# encoding: utf-8

require 'active_support'

require 'backframe/actioncontroller/acts_as_resource/actions'

module Backframe
  module ActsAsResource
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_resource(resource, *args)
        arguments = (args.present?) ? args[0] : {}

        @resource = resource
        @resource_opts = arguments

        include Helpers

        member_methods = [:show,:edit,:update,:destroy]
        if arguments.key?(:has_many)
          member_methods.concat(arguments[:has_many])
        end

        if arguments.key?(:only)
          member_methods = (member_methods.to_set & arguments[:only].to_set).to_a
        end

        if arguments.key?(:except)
          member_methods = (member_methods.to_set - arguments[:except].to_set).to_a
        end

        before_action :load_item, only: member_methods

        include Actions::Index     if include_method?(arguments, :index)
        include Actions::Create    if include_method?(arguments, :create)
        include Actions::Show      if include_method?(arguments, :show)
        include Actions::Edit      if include_method?(arguments, :edit)
        include Actions::Update    if include_method?(arguments, :update)
        include Actions::UpdateAll if include_method?(arguments, :update)
        include Actions::Destroy   if include_method?(arguments, :destroy)

        if arguments.key?(:has_many)
          arguments[:has_many].each do |association|
            class_eval <<-EOV
              def #{association}
                page(@item.#{association})
              end
            EOV
          end
        end
      end

      def resource; @resource; end
      def resource_opts; @resource_opts; end

      private

      def include_method?(arguments, method)
        (arguments[:only].present? && arguments[:only].include?(method)) ||
          (arguments[:except].present? && !arguments[:except].include?(method)) ||
          (arguments[:only].nil? && arguments[:except].nil?)
      end
    end
  end

  module Helpers
    def resource
      self.class.resource.constantize
    rescue NameError
      instance_eval self.class.resource
    end

    def load_item
      @item = resource.find(params[:id])
    end

    def allowed_params
      allowed = params.permit(self.class.resource_opts[:allowed])
      self.class.resource_opts[:allowed].each do |attribute|
        if attribute.is_a?(Hash)
          attribute.each do |key,value|
            if value.is_a?(Array) && !allowed.key?(key)
              allowed[key] = []
            end
          end
        end
      end
      allowed
    end
  end
end
