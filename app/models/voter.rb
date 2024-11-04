# frozen_string_literal: true

class Voter < VoidableRecord
  has_secure_password
  has_many :votes, dependent: :destroy

  validates :name, presence: true
  validates :email, email: true, presence: true, uniqueness: { case_sensitive: false }
end
