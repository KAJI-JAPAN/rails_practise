class User < ApplicationRecord
  has_many :follows_as_follower, class_name: 'Follow', foreign_key: 'follower_id'
  has_many :followings, through: :follows_as_follower, source: :followed

  has_many :follows_as_followed, class_name: 'Follow', foreign_key: 'followed_id'
  has_many :followers, through: :follows_as_followed, source: :follower
end

# 設問：
# •	上記のコードは何を実現している？（目的と関連を具体的に）
#   => 目的；フォローした/自分がフォローしている人、フォローされた/自分がフォローされている人を探すmodelのリレーション.SNSなどで多く見かける
#   => 関連：
#       - follows_as_followerでは自分がフォローしてる人と関連づける。Followテーブルのfollower_idから関連
#       - followingsでは自分がフォローした人
#       - follows_as_followedでは自分がフォローされている人
#       -followersは自分をフォローした人
# •	through: :follows_as_follower, source: :followed の意味は？
#   - follows_as_followerを媒介してfollowedにアクセスする