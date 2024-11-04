# frozen_string_literal: true

class Election < ApplicationRecord
  with_options dependent: :destroy do |assoc|
    assoc.has_many :candidates
    assoc.has_many :votes
  end

  enum :status, { open: 0, closed: 1 }, suffix: true, default: :open

  attr_readonly :candidates_count, :votes_count

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :year, message: 'must be unique for each year' }
  validates :year, :start_time, :end_time, presence: true

  def voting_status
    if Time.current < start_time
      :not_started
    elsif Time.current > end_time
      :ended
    else
      :open
    end
  end
end
