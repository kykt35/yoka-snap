class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  before_validation :set_slug

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  private
    def set_slug
      self.slug = name.to_s.parameterize.presence || name.to_s if slug.blank?
    end
end
