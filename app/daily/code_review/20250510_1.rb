class NotificationsController < ApplicationController
  def mark_all_as_read
    current_user.notifications.each do |notification|
      notification.update(read: true)
    end
    render json: { message: 'All notifications marked as read' }
  end
end

# 💡レビューの観点（次の2つを答えてください）
# 1.	この実装の改善点や問題点を2つ以上指摘してください
#     - 繰り返し処理の中でDBの更新をかけている
#     - 全ての通知を読んだという条件式がないため要件を満たせているかわからない(最初に未読の数を取得してそれらが既読になったか判断するなどして例外を出した方が良さそう)
#
# 2.	実務で使えるようにするためのリファクタ案を提案してください（セキュリティ、パフォーマンス、設計など）

class NotificationsController < ApplicationController
  def mark_all_as_read
    unread = current_user.notification.where(read: false)
    # update_allは件数を返す
    update_count = unread.update_all(read: true)

    if update_count == unread.count
      render json: { message: 'All notifications marked as read' }, status: :ok
    else
      render json: { message: 'Some notifications could not be updated' }, status: :internal_server_error
    end
  end
end