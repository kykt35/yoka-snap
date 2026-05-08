class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true

  def admin?
    user.present? && AdminRole.exists?(user: user)
  end
end
