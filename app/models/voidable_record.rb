# frozen_string_literal: true

class VoidableRecord < ApplicationRecord
  self.abstract_class = true

  default_scope { where(is_voided: false).order(created_at: :asc) }

  scope :with_voided, -> { unscoped.order(created_at: :asc) }
end