
# あなたのRailsアプリでは社内用のUserモデルを使っていますが、新たに**外部の社員管理API（External HR API）**からデータを取り込む必要が出てきました。
# 外部APIレスポンス→変更不可
# {
#   "full_name": "Yamada Taro",
#   "mail_address": "yamada@example.com"
# }
#
# アプリ側で期待されているUser構造
# class User
#   attr_accessor :name, :email
# end

class AdapterUserInfo
  def initialize(user_info)
    @user_info = user_info.symbolize_keys
  end

  def to_user
    user = User.new
    user.name = @user_info[:name]
    user.email = @user_info[:mail_address]
    user
  end
end


