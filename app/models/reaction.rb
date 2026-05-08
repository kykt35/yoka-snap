# == Schema Information
#
# Table name: reactions
#
#  id            :integer          not null, primary key
#  reaction_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  post_id       :integer          not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_reactions_on_post_id                                (post_id)
#  index_reactions_on_user_id                                (user_id)
#  index_reactions_on_user_id_and_post_id_and_reaction_type  (user_id,post_id,reaction_type) UNIQUE
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#  user_id  (user_id => users.id)
#
class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  TYPES = %w[like want_to_go].freeze

  scope :like, -> { where(reaction_type: "like") }
  scope :want_to_go, -> { where(reaction_type: "want_to_go") }

  validates :reaction_type, inclusion: { in: TYPES }
  validates :reaction_type, uniqueness: { scope: [ :user_id, :post_id ] }
end
