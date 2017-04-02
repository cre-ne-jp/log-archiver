class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username

  authenticates_with_sorcery!

  validates(
    :username,
    presence: true,
    uniqueness: true,
    length: { maximum: 255 }
  )

  validates(
    :password,
    presence: true,
    length: {
      minimum: 4,
      maximum: 255
    },
    confirmation: true,
    if: :should_validate_password?
  )

  validates(
    :password_confirmation,
    presence: true,
    if: :should_validate_password?
  )

  private

  # パスワードの検証が必要かどうかを返す
  # @return [Boolean] 新規作成時またはパスワード変更時のみ true
  def should_validate_password?
    new_record? || changes[:crypted_password]
  end
end
