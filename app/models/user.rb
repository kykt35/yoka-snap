class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_one :admin_role, dependent: :destroy
  has_one_attached :avatar do |attachable|
    attachable.variant :avatar, resize_to_fill: [ 160, 160 ]
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def admin?
    admin_role.present?
  end
end
