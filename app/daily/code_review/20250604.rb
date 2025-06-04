# 以下は、ある社内業務ツールのロジックの一部です。
# 「特定のユーザーがある操作（公開処理）を実行できるかどうか」を判定するためのサービスクラスです。

# app/services/publication/permission_checker.rb

module Publication
  class PermissionChecker
    def initialize(user, publication)
      @user = user
      @publication = publication
    end

    def allowed?
      return true if user.admin?
      return false unless user.active?

      case publication.status
      when 'draft'
        can_edit_draft?
      when 'reviewing'
        can_review?
      when 'approved'
        can_publish?
      else
        false
      end
    end

    private

    attr_reader :user, :publication

    def can_edit_draft?
      user.has_role?(:editor) && same_department?
    end

    def can_review?
      user.has_role?(:reviewer) && department_manager?
    end

    def can_publish?
      user.has_role?(:publisher) && user.confirmed_at.present?
    end

    def same_department?
      user.department_id == publication.department_id
    end

    def department_manager?
      user.department.manager_id == user.id
    end
  end
end
