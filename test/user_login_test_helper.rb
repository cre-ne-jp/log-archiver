# frozen_string_literal: true

# 利用者のログイン/ログアウト操作を模擬するテストヘルパー
class UserLoginTestHelper
  # テストヘルパーを初期化する
  # @param [ActionDispatch::IntegrationTest] test テスト
  # @param [User] user ログインする利用者
  # @param [String] path ログイン後にアクセスするページのパス
  def initialize(test, user, path)
    @test = test
    @user = user
    @path = path
  end

  # ログインする
  # @return [void]
  def log_in
    @test.post(
      @test.user_sessions_path,
      params: {
        username: @user.username,
        password: 'pa$$word'
      }
    )
    @test.follow_redirect!
  end

  # ログアウトする
  # @return [void]
  def log_out
    @test.get(@test.logout_path)
    @test.follow_redirect!
  end

  # ログインが必要な画面の表示に成功することを確認する
  # @return [void]
  def assert_successful_login_and_get
    log_in
    @test.get(@path)

    @test.assert_response(:success)
  end

  # 未ログイン時にログインページにリダイレクトされることを確認する
  # @return [void]
  #
  # ブロックが与えられた場合は、ログアウト後にそのブロックを実行する。
  # ブロックが与えられなかった場合は、#path をGETする。
  def assert_redirected_to_login_on_logged_out
    log_out

    if block_given?
      yield
    else
      @test.get(@path)
    end

    @test.assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    @test.refute_nil(@test.flash[:warning], 'warningのflashが表示される')
  end
end
