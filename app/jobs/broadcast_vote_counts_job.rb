# frozen_string_literal: true

class BroadcastVoteCountsJob < ApplicationJob
  queue_as :default

  def perform(election_id)
    election = Election.preload(:candidates).find(election_id)
    candidates_by_position = election.candidates.group_by(&:position)

    # Prepare a hash to store vote counts grouped by position
    vote_counts_by_position = candidates_by_position.map do |position, candidates|
      {
        position: position,
        candidates: CandidatesRepresenter.new(candidates).as_json
      }
    end

    # Broadcast updated vote counts for each position
    VotesChannel.broadcast_to(election, {
      message: "Vote successfully cast",
      election_name: election.name,
      vote_counts_by_position: vote_counts_by_position
    })
  end
end
