# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < ApplicationController
      wrap_parameters false
      before_action :set_candidate, only: %i[show update destroy]
    
      def create
        candidate = CandidateService.create_candidate(candidate_params, params[:election_id])
        if candidate.persisted?
          render_created CandidateRepresenter.new(candidate).as_json, 'Candidate successfully created'
        else
          render_unprocessable_entity 'Failed to create candidate', candidate.errors.full_messages
        end
      end
    
      def show
        render_ok CandidateRepresenter.new(@candidate).as_json, 'Record found'
      end
    
      def update
        @candidate.avatar.purge unless candidate_params[:avatar].nil?
        if @candidate.update(candidate_params)
          render_ok CandidateRepresenter.new(@candidate).as_json, 'Candidate successfully updated'
        else
          render_unprocessable_entity 'Failed to update candidate', @candidate.errors.full_messages
        end
      end
    
      def destroy
        if @candidate.update(is_voided: true)
          render_ok CandidateRepresenter.new(@candidate).as_json, 'Candidate successfully voided'
        else
          render_unprocessable_entity 'Failed to void candidate'
        end
      end
    
      private
    
      def candidate_params
        params.permit(:name, :position_id, :avatar)
      end
    
      def set_candidate
        @candidate = Candidate.unscoped.find(params[:id])
      end
    end
  end
end
