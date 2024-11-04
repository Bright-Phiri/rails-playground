# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  # Custom Exceptions
  class InvalidUsername < StandardError
    def initialize(msg = 'Username not found')
      super
    end
  end

  class CandidateAlreadyRegisteredError < StandardError
    def initialize(candidate_name, position_name)
      super("Candidate #{candidate_name} is already registered for the position '#{position_name}' in this election.")
    end
  end

  class AlreadyVotedForPositionError < StandardError
    def initialize(position_name)
      super("You have already voted for a candidate in the position '#{position_name}'.")
    end
  end

  class InvalidEmail < StandardError
    def initialize(msg = "The email is invalid")
      super
    end
  end

  class NotAuthorized < StandardError
    def initialize(msg = 'You are not authorized to perform this action.')
      super
    end
  end

  class InvalidCredentials < StandardError
    def initialize(msg = 'Invalid credentials.')
      super
    end
  end

  class VotingNotStartedError < StandardError
    def initialize(msg = 'Voting has not started yet.')
      super
    end
  end

  class VotingEndedError < StandardError
    def initialize(msg = 'Voting has ended for this election.')
      super
    end
  end

  class AlreadyVotedError < StandardError
    def initialize(msg = 'You have already voted for this candidate in this election.')
      super
    end
  end

  included do
    # Define custom exception responses

    rescue_from ExceptionHandler::NotAuthorized do |exception|
      render json: { error: exception.message }, status: :unauthorized
    end

    rescue_from ExceptionHandler::InvalidCredentials do |exception|
      render json: { error: exception.message }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordNotFound do
      render json: { error: 'Record not found' }, status: :not_found
    end

    rescue_from InvalidUsername, InvalidEmail, CandidateAlreadyRegisteredError, AlreadyVotedForPositionError  do |exception|
      render json: { error: exception.message }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed do |exception|
      render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    rescue_from VotingNotStartedError, VotingEndedError, AlreadyVotedError do |exception|
      render json: { error: exception.message }, status: :forbidden
    end
  end
end
