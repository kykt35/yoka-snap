class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  TYPES = %w[like want_to_go].freeze

  scope :like, -> { where(reaction_type: "like") }
  scope :want_to_go, -> { where(reaction_type: "want_to_go") }

  validates :reaction_type, inclusion: { in: TYPES }
  validates :reaction_type, uniqueness: { scope: [ :user_id, :post_id ] }
end
