# frozen_string_literal: true

module VoteService
  def self.create_vote(params, election_id)
    voter = Voter.unscoped.find(params[:voter_id])
    election = Election.find(election_id)
    candidate = Candidate.unscoped.preload(:votes).find(params[:candidate_id])

    validate_voting_authorization!(voter, candidate)
    check_voting_status!(election)
    check_duplicate_vote!(voter, election, candidate)

    election.votes.create(voter: voter, candidate: candidate)
  end

  private_class_method

  def self.check_voting_status!(election)
    case election.voting_status
    when :not_started
      raise ExceptionHandler::VotingNotStartedError
    when :ended
      raise ExceptionHandler::VotingEndedError
    end
  end

  def self.validate_voting_authorization!(voter, candidate)
    raise ExceptionHandler::VoterNotAuthorized, 'Voter is voided' if voter.is_voided?
    raise ExceptionHandler::CandidateNotAuthorized, 'Candidate is voided' if candidate.is_voided?
  end

  def self.check_duplicate_vote!(voter, election, candidate)
    if candidate.votes.exists?(voter_id: voter.id, election_id: election.id)
      raise ExceptionHandler::AlreadyVotedError
    end

    if voter.votes.joins(candidate: :position).where(election_id: election.id, positions: { id: candidate.position_id }).exists?
      raise ExceptionHandler::AlreadyVotedForPositionError.new(candidate.position.name)
    end
  end
end
