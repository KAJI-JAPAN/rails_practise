class PostsController < ApplicationController
  before_action :set_user

  def index
    @posts = @user.posts
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end

# 🧠 Railsリーディング問題（コード読解）
# 1.	次のコードでbefore_action :set_userはいつ実行され、どのような目的ですか？
# 　　　- 実行タイミング：indexにアクセスしたい際にindexアクション内のコードが実行される前に実行される
# 　　　- 目的：パラーメーターからユーザーを検索して対象ユーザーを見つける
# 2.	render json: @user, status: :ok のような書き方で、Railsは内部的に何を行っていますか？
# 　　　- @userインスタンスをJson形式にしてstatus200を返す
# 3.	scope :recent, -> { where('created_at > ?', 1.week.ago) } はどういう意味ですか？使い方も含めて説明してください。
# 　　　- modelから対象のデータ取得を定義できるscopeというRailsの機能
# 　　　-作成日が一週間以内のデータをDBから取得する(User.recentのような形で使用可能)