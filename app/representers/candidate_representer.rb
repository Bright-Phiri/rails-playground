# frozen_string_literal: true

class CandidateRepresenter
  include Rails.application.routes.url_helpers

  def initialize(candidate)
    @candidate = candidate
  end

  def as_json
    {
      id: candidate.id,
      avatar: avatar_url(candidate),
      name: candidate.name,
      position: candidate.position.name,
      is_voided: candidate.is_voided,
      election_year: candidate.election.year,
      election_name: candidate.election.name,
      votes_count: candidate.votes_count
    }
  end

  private

  def avatar_url(candidate)
    candidate.avatar.attached? ? url_for(candidate.avatar) : nil
  end

  attr_reader :candidate
end
