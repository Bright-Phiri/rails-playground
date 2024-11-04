# frozen_string_literal: true

module Api
  module V1
    class Api::V1::AuthenticationController < ApplicationController
      skip_before_action :authorize_request
      wrap_parameters false
    
      def login
        if Voter.exists?
          voter = Voter.find_by(email: voter_params[:email])
          raise InvalidUsername unless voter.present?
    
          authenticate_voter(voter)
        else
          render_not_found 'No voter account found'
        end
      end
    
      private
    
      def authenticate_voter(voter)
        raise InvalidCredentials unless voter.authenticate(voter_params[:password])
    
        token = encode_token({ email: voter.email, exp: 24.hours.from_now.to_i })
    
        render_ok({ voter: voter, token: token }, 'Access granted')
      end
    
      def voter_params
        params.permit(:email, :password)
      end
    end
  end
end
