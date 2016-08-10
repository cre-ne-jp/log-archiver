class Channel < ActiveRecord::Base
  validates(:name, presence: true)
  validates(:identifier, presence: true)
  validates(:logging_enabled, presence: true)
end
