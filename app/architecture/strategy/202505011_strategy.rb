# あなたはオンライン決済システムの設計を担当しています。
# ユーザーは以下の方法で支払いを行えます：
# 	•	クレジットカード決済（即時決済）
# 	•	銀行振込（数日かかる）
# 	•	電子マネー（即時決済）
#
# 将来的には「ポイント払い」や「暗号資産払い」なども追加予定です。

class BasePayment
  def initialize(card_info)
    unless card_info
      raise "有効な支払い情報がありません"
    end
    @card_info = card_info
  end
  def pay
    pp "支払いを行いました"
  end
end

# -------
class CardPayment < BasePayment
  def initialize(card_info)
    unless card_info
      raise "有効なカード情報がありません"
    end
    @card_info = card_info
  end

  def pay
    pp "cardで支払いを行いました"
  end
end

# ---------

class BankTransfer < BasePayment
  def initialize(card_info)
    unless card_info
      raise "有効な決済情報ではありません"
    end
    @card_info = card_info
  end

  def pay
    pp "銀行払いを実行"
  end
end

#----------


class ElectronicMoneyPayment < BasePayment
  def initialize(card_info)
    unless card_info
      raise "電子マネーに関連するエラーです"
    end
    @card_info = card_info
  end

  def pay
    pp "電子決済払いを実行"
  end
end

class PaymentStrategySelector
  def self.build(type, info)
    case type
    when :card
      CardPayment.new(info)
    when :bank
    BankTransfer.new(info)
    when :electronicMoneyPayment
      ElectronicMoneyPayment.new(info)
    else
      raise "Unknown payment type: #{type}"
    end
  end
end

class PaymentProccessor
  def initialize(payment)
    @strategy = payment
  end

  def pay
    @strategy.pay
  end
end

# クレジットカード払いを選ぶ
card_strategy = PaymentStrategySelector.build(:card, "**** **** **** 1234")
PaymentProcessor.new(card_strategy).pay




#----------

