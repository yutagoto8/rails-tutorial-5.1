module SessionsHelper
    # 渡されたユーザーでログインする
    def log_in(user)
      session[:user_id] = user.id
    end

    # ユーザーのセッションを永続的にする
    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

  
    # 現在ログイン中のユーザーを返す (いる場合)
    def current_user
      if (user_id = session[:user_id])
        # 今までのセッション情報
        @current_user ||= User.find_by(id: session[:user_id])
        # セッションにはユーザー情報がなくcookieにあるパターン
      elsif (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        # cookieがあってもユーザーが消えていたりパスワードが変わっていたりするときに対応するため下記の記述を
        if user && user.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end
  
    # ユーザーがログインしていればtrue、その他ならfalseを返す
    def logged_in?
      !current_user.nil?
    end

    # 永続的セッションの破棄
    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end

    # 現在のユーザーをログアウトする
    def log_out
      # 上記のforgetメソッドを呼び出している
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
end
