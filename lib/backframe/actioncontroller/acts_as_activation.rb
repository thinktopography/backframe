require 'active_support'
require 'active_support/inflector'

module Backframe
  module ActsAsActivation
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_activation(model, *args)

        arguments = args[0]

        class_eval <<-EOV

          layout 'signin'
          before_action :load_#{model.underscore}, :except => :show

          def show
            @activation = Activation.find_by(:token => params[:token])
            if @activation.nil?
              flash[:error] = I18n.t(:activation_invalid)
              redirect_to account_signin_path
            elsif @activation.expired?
              flash[:error] = I18n.t(:activation_expired)
              redirect_to '#{arguments[:prefix]}/signin'
            else
              session.delete(:#{model.underscore}_id)
              session[:activation_id] = @activation.id
              flash[:success] = I18n.t(:activation_success)
              redirect_to '#{arguments[:prefix]}/activation/password'
            end
          end

          def password
            if request.patch?
              @user.set_password = true
              @user.attributes = params.require(:#{model.underscore}).permit([:new_password,:confirm_password])
              if @user.save
                session.delete(:activation_id)
                session[:#{model.underscore}_id] = @user.id
                @activation.claim
                redirect_to '#{arguments[:redirect]}'
              else
                flash[:error] = @user.errors[:new_password].first
              end
            end
          end

          private

            def load_#{model.underscore}
              @activation = Activation.find_by(:id => session[:activation_id])
              @user = @activation.user
              if @user.nil?
                flash[:error] = I18n.t(:activation_invalid)
                redirect_to '#{arguments[:prefix]}/signin'
              end
            end

        EOV

      end
    end

  end
end
