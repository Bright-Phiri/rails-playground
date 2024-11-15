# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :voter
  belongs_to :candidate, counter_cache: true
  belongs_to :election, counter_cache: true

  validates :voter_id, uniqueness: { scope: %i[candidate_id election_id] }

  after_create_commit :broadcast_vote_counts

  private

  def broadcast_vote_counts
    BroadcastVoteCountsJob.perform_later(election.id)
  end
end
