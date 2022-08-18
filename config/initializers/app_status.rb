# アプリケーションの状態を取得できるようにする
Rails.application.config.to_prepare do
  Rails.application.config.app_status = LogArchiver::AppStatus.new(
    LogArchiver::Version,
    Time.now,
    LogArchiver::AppStatus.get_commit_id
  )
end
