class ReportsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    if user.inactive?
      render json: { error: 'ユーザーが無効です' }, status: :unprocessable_entity
      return
    end

    report = Report.new(report_params)
    report.user = user

    if report.save
      Notification.create!(
        user: user,
        message: "レポートが作成されました",
        read: false
      )
      render json: report, status: :created
    else
      render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :content)
  end
end

#✏️ 解答フォーマット例：
# 	•	問題点1：
# 	•	理由：
# 	•	問題点2：
# 	•	理由：
# 	•	問題点3：
# 	•	理由：
# 	•	改善案（問題点◯に対して）：