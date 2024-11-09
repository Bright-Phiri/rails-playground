# frozen_string_literal: true

module Api
  module V1
    class VotersController < ApplicationController
      wrap_parameters false
      before_action :set_voter, only: %i[show update destroy]
      skip_before_action :authorize_request, only: %i[register show update]
    
      def index
        voters = Voter.with_voided
        render_ok voters, 'voters successfully retrieved'
      end
    
      def register
        voter = Voter.new(voter_params)
        if voter.save
          render_created voter, 'Voter successfully created'
        else
          render_unprocessable_entity 'Failed to register voter', voter.errors.full_messages
        end
      end
    
      def show
        render_ok @voter, 'Record found'
      end
    
      def update
        if @voter.update(voter_params)
          render_ok @voter, 'Voter successfully updated'
        else
          render_unprocessable_entity 'Failed to update voter', @voter.errors.full_messages
        end
      end
    
      def destroy
        if @voter.update(is_voided: true)
          render_ok @voter, 'Voter successfully voided'
        else
          render_unprocessable_entity 'Failed to void voter'
        end
      end
    
      private
    
      def voter_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    
      def set_voter
        @voter = Voter.unscoped.find(params[:id])
      end
    end
  end
end
