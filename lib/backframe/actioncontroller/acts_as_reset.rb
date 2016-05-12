# encoding: utf-8

require 'active_support'
require 'active_support/inflector'

module Backframe
  module ActsAsReset
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_reset(model, *args)

        arguments = args[0] || {}

        reset = arguments[:reset] || 'Backframe::Reset'

        class_eval <<-EOV

          layout 'signin'
          before_action :redirect_if_signed_in
          before_action :load_user, :except => [:new,:show]

          def new
            if request.post?
              @user = #{model}.find_by_email(params[:#{model.underscore}][:email])
              if @user && @user.reset
                flash[:error] = I18n.t(:reset_request)
                redirect_to '#{arguments[:prefix]}/signin'
              else
                flash[:error] = I18n.t(:reset_not_found)
                redirect_to '#{arguments[:prefix]}/reset'
              end
            else
              @user = #{model}.new
            end
          end

          def show
            @reset = #{reset}.find_by(:token => params[:token])
            if @reset.nil?
              flash[:error] = I18n.t(:reset_invalid)
              redirect_to '#{arguments[:prefix]}/signin'
            elsif @reset.expired?
              flash[:error] = I18n.t(:reset_expired)
              redirect_to '#{arguments[:prefix]}/signin'
            else
              @reset.claim
              session[:reset_id] = @reset.id
              flash[:error] = I18n.t(:reset_password)
              redirect_to '#{arguments[:prefix]}/reset/password'
            end
          end

          def password
            if request.patch?
              @user.set_password = true
              @user.attributes = params.require(:#{model.underscore}).permit([:new_password,:confirm_password])
              if @user.save
                session.delete(:reset_id)
                session[:#{model.underscore}_id] = @user.id
                flash[:error] = I18n.t(:reset_success)
                redirect_to '#{arguments[:redirect]}'
              else
                flash[:error] = @user.errors[:new_password].first
              end
            end
          end

          private

            def load_user
              @reset = #{reset}.find_by(:id => session[:reset_id])
              @user = @reset.user
              if @user.nil?
                flash[:error] = I18n.t(:reset_invalid)
                redirect_to account_signin_path
              end
            end

        EOV

      end
    end

  end
end
