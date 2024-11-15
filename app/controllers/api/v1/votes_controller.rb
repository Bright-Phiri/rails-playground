# frozen_string_literal: true

module Api
  module V1
    class VotesController < ApplicationController
      wrap_parameters false

      def create
        vote = VoteService.create_vote(votes_params, params[:election_id])
        if vote.persisted?
          render_created vote, "Vote successfully casted"
        else
          render_unprocessable_entity "Failed to cast vote", vote.errors.full_messages
        end
      end

      private

      def votes_params
        params.permit(:voter_id, :candidate_id)
      end
    end
  end
end
