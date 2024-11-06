# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authorize_request
      wrap_parameters false
    
      def login
        user = User.find_by(email: login_params[:email])
        
        account = user || Voter.find_by(email: login_params[:email])
        raise InvalidUsername unless account.present?

        authenticate_account(account)
      end
    
      private
    
      def authenticate_account(account)
        raise InvalidCredentials unless account.authenticate(login_params[:password])

        token = encode_token({ email: account.email, type: account.class.name, exp: 24.hours.from_now.to_i })

        render_ok({ account: account, token: token }, 'Access granted')
      end
    
      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
