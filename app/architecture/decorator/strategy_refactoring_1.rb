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
# LogDecoratorを呼び出した場合NotifyDecoratorを実行
class StrategyRefactoringCall
  def initialize(strategy)
    @strategy = strategy
  end
  def select_send_message_tool(user)
    @strategy.select_send_message_tool(user)
  end
end

# Decoratorパターンを追加する 通知系
class NotifyDecorator < NotifyStrategy
  def initialize(strategy)
    @strategy = strategy
  end

  def select_send_message_tool(user)
    @strategy.select_send_message_tool(user)
  end
end

class LogDecorator < NotifyDecorator
  def select_send_message_tool(user)
    puts "Log message sent to #{user}"
    super
  end
end

# 実行例
# notifier = LogDecorator.new(Email.new)  # EmailはNotifyStrategyを継承していると仮定
#   - LogDecoratorはNotifyDecoratorを継承しているため、NotifyDecoratorのinitializeを実行
#   -
# notifier.select_send_message_tool(user)
