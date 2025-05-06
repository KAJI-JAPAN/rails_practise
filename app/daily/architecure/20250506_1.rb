# ✅ 問題：
# 「いいね機能」を実装するとき、どのようなモデル設計をしますか？中間テーブルを含めて説明してください。

# [ユーザーに対していいねをすると仮定]
# - Userモデル-中間テーブル-いいねテーブル
# - いいねテーブルの中にはどのユーザーIDに対するいいねかがある
# - 中間テーブルではユーザーといいねテーブルをそれぞれ結びつけている

class User < ApplicationRecord
  has_many :likes_given, class_name: 'Like', foreign_key: 'liker_id'
  has_many :liked_users, through: :likes_given, source: :liked

  has_many :likes_received, class_name: 'Like', foreign_key: 'liked_id'
  has_many :likers, through: :likes_received, source: :liker
end

class Like < ApplicationRecord
  belongs_to :liker, class_name: 'User'
  belongs_to :liked, class_name: 'User'
end

# 解説
# 自分がフォローした記録　follows_as_follower
# 自分がフォローしている「ユーザー」　followings
# 自分がフォローされた「記録」　follows_as_followed
# 自分をフォローしてくれる「ユーザー」　followers

create_table :follows do |t|
  t.references :follower, null: false, foreign_key: { to_table: :users }
  t.references :followed, null: false, foreign_key: { to_table: :users }

  t.timestamps

  t.index [:follower_id, :followed_id], unique: true
end

# users        users
# ↑             ↑
# |             |
# follower   followed
# |             |
# followsーーーーー