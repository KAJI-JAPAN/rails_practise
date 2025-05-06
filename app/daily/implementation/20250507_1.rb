class User < ApplicationRecord
  # カラム: id, name, email, active:boolean

  scope: 
end

# 以下の要件を満たす スコープ active_users を User モデルに実装してください：
#
# 要件
# •	activeカラムが true のユーザーだけを返す
# •	スコープ名は active_users
# •	呼び出し例は User.active_users
# •	必要であればRSpecも書いてください（任意）