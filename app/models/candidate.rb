# frozen_string_literal: true

class Candidate < VoidableRecord
  has_one_attached :avatar
  belongs_to :position
  belongs_to :election, counter_cache: true
  has_many :votes, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
