# encoding: utf-8

require 'active_support'
require 'active_support/inflector'

module Backframe
  module ActsAsSession
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_session(model, *args)

        arguments = args[0] || {}

        class_eval <<-EOV

          layout 'signin'
          before_action :redirect_if_signed_in, :except => [:application,:destroy]
          before_action :authenticate_#{model.underscore}, :only => :application

          def application
            render :layout => false
          end

          def new
            @user = #{model}.new
          end

          def create
            if @user = #{model}.find_by_email(params[:#{model.underscore}][:email])
              if @user.locked_out?
                flash[:error] = I18n.t(:session_locked)
                session[:signin_locked] = true
                redirect_to '#{arguments[:prefix]}/signin'
              elsif @user.authenticate(params[:#{model.underscore}][:password])
                @user.signin(:success)
                session.delete(:signin_locked)
                session[:#{model.underscore}_id] = @user.id
                url = session[:redirect_to] || '#{arguments[:redirect]}'
                redirect_to url
              else
                @user.signin(:failed)
                if @user.locked_out?
                  session[:signin_locked] = true
                  flash[:error] = I18n.t(:session_locking)
                else
                  flash[:error] = I18n.t(:session_invalid)
                end
                redirect_to '#{arguments[:prefix]}/signin'
              end
            else
              flash[:error] = I18n.t(:session_not_found)
              redirect_to '#{arguments[:prefix]}/signin'
            end
          end

          def destroy
            flash[:success] = I18n.t(:session_signout)
            session.delete(:redirect_to)
            session.delete(:#{model.underscore}_id)
            redirect_to '#{arguments[:prefix]}/signin'
          end

          private

            def authenticate_#{model.underscore}
              if !signed_in?
                flash[:warning] = I18n.t(:session_interception)
                session[:redirect_to] = request.path
                redirect_to '#{arguments[:prefix]}/signin'
              end
            end

        EOV

      end
    end

  end
end
