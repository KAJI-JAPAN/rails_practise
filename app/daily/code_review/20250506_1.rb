# app/services/order_processor.rb
class OrderProcessor
    def initialize(order)
      @order  = order
    end
  
    def order_processing_transaction
      ActiveRecord::Base.transaction do
        calculate_total
        charge_customer
        send_receipt
      end
    rescue StandardError => e
      Rails.logger.error(e.message)
      raise e
    end
  
    private
  
    def calculate_total
      @order.total_price = @order.items.sum(&:price)
      @order.save!
    end
  
    def billing_customers
      PaymentGateway.charge(@order.user, @order.total_price)
    end
  
    def send_receipt
      ReceiptMailer.with(order: @order).deliver_later
    end
  end

#   気になる点
# - @cartの命名
# 　- cart内の商品という意味だと思うので、どのような商品を扱っているかによって命名を具体にすべきだと思う(例 goods、merchandise
# - calculateメソッドの命名
#   - calcurateメソッドは実際には計算しておらず、送料の料金を確認しているだけなので、shipping_rule_applyなどで良いと思う
#   - エラーに関しては本当にraiseでいいのか不明。送料が適用されない商品があるのであれば良いがないのであればおかしいのでraise eでエラーとして良い
# - ルールでクラスを分けているのに違和感がある
# 　- 分けるならルールが適用されるか？といったメソッド名にすべき
# - ルール内の計算構造は全て同じメソッド達なので抽象化すべきだと思う