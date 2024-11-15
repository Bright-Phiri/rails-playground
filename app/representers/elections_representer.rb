# frozen_string_literal: true

class ElectionsRepresenter
  def initialize(elections)
    @elections = elections
  end

  def as_json
    elections.map do |election|
      {
        id: election.id,
        name: election.name,
        year: election.year,
        start_time: election.start_time,
        end_time: election.end_time,
        total_candidates: election.candidates_count,
        total_votes: election.votes_count
      }
    end
  end

  private

  attr_reader :elections
end
