# 要件：
# •	対象ユーザーを退会処理する。
# •	ユーザーの active フラグを false にする。
# •	関連する Session レコードを全削除する。
# •	トランザクションで処理をまとめる。

class User::DeactivateService
  belongs_to :session, dependent: :destroy

  def initialize(user)
    @user = user
  end
  def withdrawal
    @user.transaction do
      @user.session.destroy
      @user.update(active: false)
    end
  end
end


#修正
# service
class User::DeactivateService
  def initialize(user)
    @user = user
  end
  def withdrawal
    ActiveRecord::Base.transaction do
      @user.session.destroy_all
      @user.update!(active: false)
    end
  rescue => e
    Rails.logger.error "ユーザーの退会処理に失敗しました#{e.message}"
  end
end

# model
class User < ActiveRecord
  has_many :sessions, dependent: :destroy
end