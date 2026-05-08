# == Schema Information
#
# Table name: admin_roles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_admin_roles_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class AdminRole < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
end
