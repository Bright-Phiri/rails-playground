# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, email: true, presence: true, uniqueness: { case_sensitive: false }
end
