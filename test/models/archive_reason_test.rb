require 'test_helper'

class ArchiveReasonTest < ActiveSupport::TestCase
  setup do
    @archive_reason = create(:archive_reason)
  end

  test '有効である' do
    assert(@archive_reason.valid?)
  end

  test 'reason は必須' do
    @archive_reason.reason = ''
    refute(@archive_reason.valid?)
  end
end
