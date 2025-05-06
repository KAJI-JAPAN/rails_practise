class Notifier
  def notify(user, type)
    if type == :email
      puts "Email sent to #{user.email}"
    elsif type == :sms
      puts "SMS sent to #{user.phone_number}"
    elsif type == :slack
      puts "Slack message sent to #{user.slack_id}"
    else
      raise "Unknown notification type"
    end
  end
end

#  ここからリファクタ
#  1. それぞれのクラスを分ける
#  2. 共通処理を継承する
#  3. メソッドを共通化する
#  4. 共通で呼び出せるようにするメソッドを作成する
class NotifyStrategy
    def select_send_message_tool(notify_info)
    raise "Unknown notification type"
  end
end

class Email < NotifyStrategy
  def select_send_message_tool(notify_info)
    puts "Email sent to #{notify_info.email}"
  end
end

class Sms < NotifyStrategy
  def select_send_message_tool(notify_info)
    puts "SMS sent to #{notify_info.phone_number}"
  end
end

class Slack < NotifyStrategy
  def select_send_message_tool(notify_info)
    puts "Slack message sent to #{notify_info.slack_id}"
  end
end

# 選択する場合
class SelectedStrategy
  def self.build(type)
    case type
    when :email
      Email.new
    when :sms
      Sms.new
    when :slack
      Slack.new
    else
      raise "Unknown strategy type #{type}"
    end
  end
end

# 他のクラスで使用する場合
class StrategyRefactoringCall
  def initialize(strategy)
    @strategy = strategy
  end
  def select_send_message_tool(user)
    @strategy.select_send_message_tool(user)
  end
end

# 使い方
# StrategyRefactoringCall.new(Email.new).select_send_message_tool
# StrategyRefactoringCall.new(Sms.new).select_send_message_tool
# StrategyRefactoringCall.new(Slack.new).select_send_message_tool



# StrategyRefactoringCallとSelectedStrategyは責務が違う
#   - SelectedStrategyで選んでStrategyRefactoringCallで使用する
#   - 使用例
#   - 目的；SMSを使用したい
# 　  sms = SelectedStrategy(sms)
#     sms_send = StrategyRefactoringCall.new(sms)

