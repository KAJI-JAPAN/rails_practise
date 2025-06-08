class ReportService
  def self.call(user_id, report_params)
    new(user_id, report_params).call
  end

  def initialize(user_id, report_params)
    @user = User.find_by(id: user_id)
    @report_params = report_params
  end

  def call
    return failure(['ユーザーが存在しません']) unless @user
    return failure(['ユーザーが無効です']) if @user.inactive?

    ActiveRecord::Base.transaction do
      report = @user.reports.build(@report_params)
      if report.save
        Notification.create!(
          user: @user,
          message: "レポートが作成されました",
          read: false
        )
        return success(report)
      else
        return failure(report.errors.full_messages)
      end
    end
  rescue => e
    Rails.logger.error(e.message)
    return failure(['内部エラーが発生しました'])
  end

  private

  def success(report)
    { success: true, report: report, errors: nil }
  end

  def failure(errors)
    { success: false, report: nil, errors: Array(errors) }
  end
end

#Structを使用する
class ReportService

  Result = Struct.new(:report, :errors, :successes?)
  def self.call(user_id, report_params)
    new(user_id, report_params).call
  end

  def initialize(user_id, report_params)
    @user = User.find_by(id: user_id)
    @report_params = report_params
  end

  def call
    return failure(['ユーザーが存在しません']) unless @user
    return failure(['ユーザーが無効です']) if @user.inactive?

    ActiveRecord::Base.transaction do
      report = @user.reports.build(@report_params)
      create_notification(@user)
      if report.save
        return Result.new(report, nil, true)
      else
        return Result.new(nil, report.errors.full_messages, false)
      end
    end
  rescue => e
    Rails.logger.error(e.message)
    return failure(['内部エラーが発生しました'])
  end

  private
  def create_notification(user)
    Notification.create!(
      user: user,
      message: "レポートが作成されました",
      read: false
    )
  end

  def failure(errors)
    Result.new(errors, false, true)
  end
end