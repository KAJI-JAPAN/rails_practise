# 以下のコードを読んで、このクラスの目的と処理の流れを日本語で説明してください。

# app/services/order_canceller.rb
class OrderCanceller
  def initialize(order)
    @order = order
  end

  def execute
    return false unless cancellable?

    ActiveRecord::Base.transaction do
      @order.update!(status: 'cancelled')
      @order.line_items.each(&:restock!)
    end

    true
  end

  private

  def cancellable?
    @order.status == 'pending' || @order.status == 'processing'
  end
end

# クラスの目的
#   - 注文をキャンセルするクラス
# 処理の流れ
#   - executeでキャンセル処理を実行
#   - execute内はtrue/falseが返り血となり、trueの場合はキャンセル処理成功、falseの場合はキャンセル処理失敗
#   - キャンセルできるかどうかを判断する。pending状態またはprocessing状態の時はキャンセル可能とする
#   - Transaction内でキャンセル状態に変更しえtデータを保存する。
#   - @order.line_items.each(&:restock!)はわからない
#     => おそらく商品を戻したりしている。その中に注文に含まれる商品の明細（1商品ごとの行）があるはずLineItem = { 商品ID, 数量, 状態, ... }
#     => 商品にrestock関数をそれぞれ実行する