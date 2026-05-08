class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :reactions, dependent: :destroy
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_fill: [640, 420]
    attachable.variant :large, resize_to_limit: [1200, 900]
  end

  STATUSES = %w[draft published hidden rejected].freeze
  AREAS = [
    "天神・大名",
    "博多",
    "中洲・春吉",
    "大濠・六本松",
    "百道・西新",
    "薬院・平尾",
    "糸島"
  ].freeze
  RECOMMENDED_TIMES = %w[朝 昼 夕方 夜].freeze

  scope :published, -> { where(status: "published") }
  scope :newest, -> { order(created_at: :desc) }
  scope :by_area, ->(area) { where(area: area) if area.present? }
  scope :tagged_with, ->(slug) { joins(:tags).where(tags: { slug: slug }) if slug.present? }

  validates :title, :area, :address, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :area, inclusion: { in: AREAS }
  validate :at_least_one_image

  def likes_count
    reactions.like.count
  end

  def want_to_go_count
    reactions.want_to_go.count
  end

  private
    def at_least_one_image
      errors.add(:images, "を1枚以上添付してください") unless images.attached?
    end
end
