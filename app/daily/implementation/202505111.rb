class User < ApplicationRecord
  has_many :follows_as_follower, class_name: 'Follow', foreign_key: 'follower_id'
  has_many :followings, through: :follows_as_follower, source: :followed

  has_many :follows_as_followed, class_name: 'Follow', foreign_key: 'followed_id'
  has_many :followers, through: :follows_as_followed, source: :follower

  scope :with_followers_from_domain, ->(domain) {
    joins(follows_as_followed: :follower)
      .where("followers_users.email LIKE ?", "%@#{domain}")
      .distinct
  }
end
# 前提
#   Follow classで依存環駅定義済み
#   class Follow < ApplicationRecord
#     belongs_to :follower, class_name: 'User'
#     belongs_to :followed, class_name: 'User'
#   end
# 注意
#   - follows_as_follower => has_manyの定義、Users → Followsのfollow_id
#   - follower => 前提が必須

# User.joins(follows_as_followed: :follower).to_sqlのように.to_sqlを使用することでSQLのクエリを確認できる