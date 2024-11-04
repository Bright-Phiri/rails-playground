# frozen_string_literal: true

module Api
  module V1
    class ElectionsController < ApplicationController
      wrap_parameters false
      before_action :set_election, only: [:show, :update, :destroy]
    
      def index
        elections = Election.all
        render_ok ElectionsRepresenter.new(elections).as_json, 'Elections successfully retrieved'
      end
    
      def show
        render_ok ElectionRepresenter.new(@election).as_json, 'Record found'
      end
    
      def show_election_candidates
        election = Election.preload(:candidates).find(params[:id])
        render_ok CandidatesRepresenter.new(election.candidates).as_json, 'Election candidates successfully retrieved'
      end
    
      def create
        election = Election.new(election_params)
        if election.save
          render_created election, 'Election successfully created'
        else
          render_unprocessable_entity 'Failed to create election', election.errors.full_messages
        end
      end
    
      def update
        if @election.update(election_params)
          render_ok @election, 'Election successfully updated'
        else
          render_unprocessable_entity 'Failed to update election', @election.errors.full_messages
        end
      end
    
      def destroy
        @election.destroy!
        head :no_content
      end
    
      private
    
      def election_params
        params.permit(:year, :name, :start_time, :end_time)
      end
    
      def set_election
        @election = Election.find(params[:id])
      end
    end
  end
end
