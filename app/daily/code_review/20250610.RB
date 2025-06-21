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
class ArticlesController

end

class UserRegistrationService
  Result = new Struct(:success?, :error, keyword_init: true)

  def initialize(user_params)
    @user_params = user_params
  end

  def call
    UserValidation.valid(@user_params)
    user = User.new(@user_params)

    if user.save
      { success: true, user: user }
    else
      { success: false, error: user.errors.full_messages.join(", ") }
    end
  end
end

class UserValidation
  def self.valid(param)
    new(param).valid
  end

  def initialize(params)
    @user_params = params
  end

  def valid
    return empty_mail || empty_password || wrong_password || success(@user_params)
  end

  private

  def empty_mail
    if @user_params[:email].blank?
      error(['メールアドレスが空です'])
    end
  end

  def empty_password
    if @user_params[:password].blank?
      error(['パスワードが空です'])
    end
  end

  def wrong_password
    if @user_params[:password].length < 6
      error(['パスワードが違います'])
    end
  end

  def success(param)
    Result.new(success: true, error: nil)
  end

  def error(message)
    Result.new(success: false, error: message)
  end
end
