# app/models/user_filter.rb
class UserFilter
  def initialize(scope, params)
    @scope = scope
    @params = params
  end

  def call
    result = @scope
    result = result.where(gender: @params[:gender]) if @params[:gender].present?
    result = result.where("age >= ?", @params[:min_age]) if @params[:min_age].present?
    result = result.where("age <= ?", @params[:max_age]) if @params[:max_age].present?
    result = result.where(active: true) unless @params[:include_inactive]
    result
  end
end

#以下について答えてください：
# 	1.	**コードレビューとして気になる点（可読性・保守性・セキュリティ）**を挙げてください。
# 	2.	より良くするためのリファクタリング案があれば提案してください。

#- セキュリティ面：受け取ったパラメーターをそのまま利用しているためSQLインジェクションの可能性がある
# -可読性；
#   - presentで空かどうかの判定は関数化して共通処理とする
# 　- その他条件分岐に関しても最初に済ませる
# 　- result.whereなどはメソッドチェインを利用して毎回resultに代入しない
# -パフォーマンス
#   - whereを多用してDBにアクセスし過ぎているのでDBへの負荷が高い

# =>
# @paramsをparams.symbolize_keysで変換してあげる
#　Railsの where("age >= ?", ...) のようなプレースホルダ付きクエリは プリペアドステートメントとして安全
#   プリペアドステートメントとは？プログラム上で動的にSQL文を生成する必要があるとき、可変部分を変数のようにしたSQL文をあらかじめ作成しておき、値の挿入は処理系に行わせる方式。
#   安全（プリペアドステートメント）
#     where("age >= ?", params[:min_age])

#    危険（SQLインジェクション）
#     where("age >= #{params[:min_age]}")
# 実は .where(...).where(...).where(...) と連ねたとしても、ActiveRecordでは実行時に1つのSQLにまとめられる → 何回 where を呼んでもSQLは1回

# リファクタ例
class UserFilter
  def initialize(scope, params)
    @scope = scope
    @params = params.symbolize_keys
  end

  def call
    @scope
      .then { |q| @params[:gender].present? ? q.where(gender: @params[:gender]) : q }
      .then { |q| @params[:min_age].present? ? q.where("age >= ?", @params[:min_age]) : q }
      .then { |q| @params[:max_age].present? ? q.where("age <= ?", @params[:max_age]) : q }
      .then { |q| @params[:include_inactive] ? q : q.where(active: true) }
  end
end