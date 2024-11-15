# frozen_string_literal: true

class ElectionRepresenter
  def initialize(election)
    @election = election
  end

  def as_json
    {
      id: election.id,
      name: election.name,
      year: election.year,
      start_time: election.start_time,
      end_time: election.end_time,
      total_candidates: election.candidates_count,
      total_votes: election.votes_count,
      candidates: CandidatesRepresenter.new(election.candidates).as_json
    }
  end

  private

  attr_reader :election
end
