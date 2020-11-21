# frozen_string_literal: true

module LogArchiver
  # ログイン状態のみルーティングを許可するためのクラス
  # Sidekiq::Web (dashboard) に使用する
  class AuthConstraint
    def matches?(request)
      return false unless request.session[:user_id]

      User.find(request.session[:user_id])
    end
  end
end
