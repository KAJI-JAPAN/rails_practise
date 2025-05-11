class UsersController < ApplicationController
  def index
    users = User.all
    if params[:active_only]
      users = users.select { |user| user.active }
    end
    render json: users
  end
end

# 🔍 1. 問題点を2つ以上指摘してください
#     => パラメーターのチェックは最初にやった方がいい
#     => usersに再代入はやめた方が可読性とコードの面でもいい
#     => josonで返すならstatusも返した方が良い
# （例：パフォーマンス、保守性、セキュリティ、設計上の課題など）
#
# 🛠 2. それを踏まえて、リファクタリング案を提示してください
#
class UsersController < ApplicationController
  def index
    return false unless params[:active_only]

    users = User.all
    active_user = users.select { |user| user.active }

    render json: active_user, status: :ok
  end
end

# 再修正
class UsersController < ApplicationController
  def index
    return render json: [], status: :ok unless params[:active_only]

    users = User.all
    active_user = users.where(active: true)

    render json: active_user, status: :ok
  end
end