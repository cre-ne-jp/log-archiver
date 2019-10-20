FactoryBot.define do
  factory :setting do
    id { 1 }
    site_title { 'IRC ログアーカイブ' }
    text_on_homepage { 'このサイトでは IRC ログを記録しています。' }

    initialize_with {
      Setting.find_or_initialize_by(id: id) do |new_setting|
        new_setting.attributes = attributes
      end
    }
  end
end
