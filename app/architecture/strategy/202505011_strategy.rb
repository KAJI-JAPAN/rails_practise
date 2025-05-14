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
      pp "有効なカード情報がありません"
    end
  end

end

# -------
class CardPayment
  
end

# ---------

class BankTransfer

end

#----------


class ElectronicMoneyPayment

end

#----------

