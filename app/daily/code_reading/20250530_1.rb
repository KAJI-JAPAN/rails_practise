# 以下のRailsコードの目的と、改善ポイントがあれば説明してください。
class OrdersController < ApplicationController
  def index
    @orders = Order.all

    @orders = @orders.select { |order| order.delivered? }
    render json: @orders
  end
end

# selectを使用しているのでパフォーマンスが悪い。
# statusを返した方が良い

# リファクタ
class OrdersController < ApplicationController
  def index
    # whereを使用してDB上で絞り込む
    # selectはRubyの配列操作なので遅い。大量データがある場合にパフォーマンスが心配
    @orders = Order.where(status: :delivered)

    render json: { orders: @orders }, status: :ok
  end
end
