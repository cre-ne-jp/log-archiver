class CanonicalUrlTemplateValidator < ActiveModel::EachValidator
  # Channel.canonical_url_template を検証する
  # @return [void]
  def validate_each(record, attribute, value)
    unless url = value.match(/\A#{URI::regexp(%w(http https))}\z/)
      record.errors.add(:canonical_url_template, 'URI の形式が誤っています')
    end

    unless url[4]
      record.errors.add(:canonical_url_template, 'ホスト名がありません')
    end
  end
end
