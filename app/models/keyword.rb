class Keyword < ApplicationRecord
  validates(:title,
            presence: true)
  validates(:display_title,
            presence: true)
end
