# vim: fileencoding=utf-8

#require_relative '../../config/version'

module LogArchiver
  module Ircs
    # アプリケーション名、バージョン、コミットID
    APP_NAME_VERSION_COMMIT_ID =
      "IRC Log Archiver (IRC bot) #{Rails.application.config.app_status.version_and_commit_id}"
  end
end
