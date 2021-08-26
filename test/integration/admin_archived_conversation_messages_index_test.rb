# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'
require 'admin_nav_item_test_helper'

class AdminArchivedConversationMessagesIndexTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(
      self, @user, admin_archived_conversation_messages_path
    )
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out
  end

  test 'ログインしていてアーカイブされたメッセージがない場合、表示される' do
    @login_helper.assert_successful_login_and_get
  end

  test 'ログインしていてアーカイブされたメッセージがある場合、表示される' do
    reason = create(:archive_reason)
    privmsg = create(:privmsg)
    privmsg_id = privmsg.id

    archived_privmsg = ConversationMessageArchiver.new.archive!({
      old_id: privmsg.id,
      archive_reason_id: reason.id,
    })

    assert_equal(privmsg_id, archived_privmsg.old_id)

    @login_helper.assert_successful_login_and_get
  end

  test '正しい管理メニュー項目がハイライトされる' do
    @login_helper.assert_successful_login_and_get
    AdminNavItemTestHelper.assert_highlighted(self, :admin_nav_archived_messages)
  end
end
