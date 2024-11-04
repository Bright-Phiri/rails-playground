# frozen_string_literal: true

module CandidateService
  def self.create_candidate(params, election_id)
    election = Election.preload(:candidates).find(election_id)
    position = Position.find(params[:position_id])
  
    existing_candidate = election.candidates.find_by(name: params[:name], position_id: position.id)
    raise ExceptionHandler::CandidateAlreadyRegisteredError.new(existing_candidate.name, position.name) unless existing_candidate.nil?
  
    election.candidates.create(params.merge(position_id: position.id))
  end
end