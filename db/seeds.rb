# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# 管理者ユーザーを作成
admin1 = User.create!(
  name: "あどみん",
  email: "admin@admin.com",
  password: "admin",
  password_confirmation: "admin",
  role: 1
)

admin2 = User.create!(
  name: "あどみん1",
  email: "admin1@admin.com",
  password: "admin",
  password_confirmation: "admin",
  role: 1
)

# 管理者ユーザーに関連付けた記事を作成
articles1 = [
  { title: "あどみんの記事1", body: "これはあどみんの最初の記事です。" },
  { title: "あどみんの記事2", body: "これはあどみんの2番目の記事です。" }
]

articles2 = [
  { title: "あどみん1の記事1", body: "これはあどみん1の最初の記事です。" },
  { title: "あどみん1の記事2", body: "これはあどみん1の2番目の記事です。" }
]

articles1.each do |article|
  admin1.articles.create!(article)
end

articles2.each do |article|
  admin2.articles.create!(article)
end

puts "初期データの作成が完了しました。"
