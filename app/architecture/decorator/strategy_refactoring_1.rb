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

# Decoratorパターンを追加する

