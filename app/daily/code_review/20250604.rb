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

# 1. 目的：
# 権限チェックをしたい
#   管理者の場合はスーパー権限は全て実行可能
#   アクティブユーザーではない場合はfalseになり権限なし
#   その後、公開処理についてstatusごとに権限があるかを確認しており、 編集権限、レビュー権限、最後に公開できるかを許可できるかをチェックしている
#   それぞれの具体的なコード内容については編集権限を持ってりかつ部署権限を持っているか、レビューに関しはreviewer権限と部署のマネージャー権限を持っているか
#   公開権限に関してはpublisher権限を持っており、公開を確認した時間が空じゃないか。つまり公開をOKな状態かを確認している
#
# 2. 問題点：
#     権限が増えた場合に辛さが出てくる。allowed?内に権限をどんどん追加していかなくてはならずallowed?のテストを行う必要がある
#     抽象クラスを作成してそれぞれの権限と上位のアクセスする人が抽象クラスにアクセスする醸造にする
#     上記によってテストのしやすさ(モックを使用する、テストをモジュールごとにできる、最低限で済む)、保守性(クラスに追加して使う側は意識しなくても良い)、拡張性が上がる(追加しやすい、ロジックが壊れてインシデントになる確率を減らせる)

# 3. 評価：
#   10点中6点　業務だとしても許容できるレベル。読みやすいし拡張がないとするなら悪くない。それぞれおの命名に関しても分かりやすい。
#   しかし、プロダクト的に権限周りは複雑になりがちなのでしっか直せるなら直した方がいい。特に問題点の解決をしないと後々辛さがでそう

# 4. リファクタ案：

module Publication
  class PermissionCheckerService
    def initialize(user, publication)
      @user = user
      @publication = publication
    end

    def allowed?
      return true if user.admin?
      return false unless user.active?

      strategy.allowed?
    end

    private

    attr_reader :user, :publication

    def strategy
      case publication.status
      when 'draft' then DraftPermission.new(user, publication)
      when 'reviewing' then ReviewingPermission.new(user, publication)
      when 'approved' then ApprovedPermission.new(user, publication)
      else NullPermission.new
      end
    end
  end
end

class Permissionbase
  def intialize(user, publication)
    @user = user
    @publication = publication
  end

  private

  attr_reader :user, :publication
end


class Draftpermission < Permissionbase
  def allowed?
    user.has_role?(:editor) && user.department_id == publication.department_id
  end
end

class ReviewingPermission < Permissionbase
  def allowed?
    user.has_role?(:reviewer) &&  user.department.manager_id == user.id
  end
end

class ApprovePermission < Permissionbase
  def allowed?
    user.has_role?(:publisher) && user.confirmed_at.present?
  end
end

class NullPermission
  def allowed?
    false
  end
end

