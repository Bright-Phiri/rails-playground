# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      wrap_parameters false
      before_action :set_user, only: %i[show update destroy]
      skip_before_action :authorize_request, only: :register

      def index
        users = User.all
        render_ok users, "Users successfully retrieved"
      end

      def register
        user = User.new(user_params)
        if user.save
          render_created user, "User successfully created"
        else
          render_unprocessable_entity "Failed to register user", user.errors.full_messages
        end
      end

      def show
        render_ok @user, "User record found"
      end

      def update
        if @user.update(user_params)
          render_ok @user, "User successfully updated"
        else
          render_unprocessable_entity "Failed to update user", @user.errors.full_messages
        end
      end

      def destroy
        @user.destroy!
        head :no_content
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
