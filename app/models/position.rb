# frozen_string_literal: true

class Position < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
