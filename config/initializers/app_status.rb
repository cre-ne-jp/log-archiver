# アプリケーションの状態を取得できるようにする
Rails.application.config.app_status = LogArchiver::AppStatus.new(
  LogArchiver::VERSION,
  Time.now,
  LogArchiver::AppStatus.get_commit_id
)
