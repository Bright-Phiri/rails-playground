# frozen_string_literal: true

class VotesChannel < ApplicationCable::Channel
  def subscribed
    election = Election.find(params[:election_id])
    stream_for election
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    BroadcastVoteCountsJob.perform_later(data["election_id"])
  end
end
