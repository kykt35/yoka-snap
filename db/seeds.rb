# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
tags = [
  "海",
  "夜景",
  "カフェ",
  "路地",
  "公園",
  "神社",
  "レトロ",
  "夕日",
  "雨の日",
  "駅近",
  "人少なめ",
  "穴場",
  "友達と撮りたい",
  "デート",
  "動画向き",
  "スマホで撮れる",
  "ばり映え",
  "ちょうどよか"
]

tags.each do |name|
  Tag.find_or_create_by!(name: name)
end

user = User.find_or_initialize_by(email_address: "user@example.com")
user.assign_attributes(name: "よかユーザー", password: "password")
user.save!

admin = User.find_or_initialize_by(email_address: "admin@example.com")
admin.assign_attributes(name: "管理者", password: "password")
admin.save!
AdminRole.find_or_create_by!(user: admin)

avatar_path = Rails.root.join("public/icon.png")
[ user, admin ].each do |account|
  next if account.avatar.attached?

  account.avatar.attach(io: File.open(avatar_path), filename: "avatar.png", content_type: "image/png")
end

sample_post = user.posts.find_or_initialize_by(title: "大濠公園の夕暮れ")
sample_post.assign_attributes(
  description: "池のまわりを歩きながら、夕方の光がきれいに撮れるスポットです。",
  area: "大濠・六本松",
  address: "大濠公園",
  recommended_time: "夕方",
  status: "published"
)
sample_post.tags = Tag.where(name: [ "公園", "夕日", "ちょうどよか" ])
unless sample_post.images.attached?
  sample_post.images.attach(io: File.open(Rails.root.join("public/icon.png")), filename: "sample.png", content_type: "image/png")
end
sample_post.save!
