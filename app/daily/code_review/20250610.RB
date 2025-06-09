class UserRegistrationService
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    if @user_params[:email].blank?
      return { success: false, error: "メールアドレスが空です" }
    end

    if @user_params[:password].blank?
      return { success: false, error: "パスワードが空です" }
    end

    if @user_params[:password].length < 6
      return { success: false, error: "パスワードが短すぎます" }
    end

    user = User.new(@user_params)

    if user.save
      { success: true, user: user }
    else
      { success: false, error: user.errors.full_messages.join(", ") }
    end
  end
end

# 「読みやすさや責務分離」の観点でのレビューコメント＋リファクタ案を提出してください。