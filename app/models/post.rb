class Post < ApplicationRecord
  attribute :visible, :boolean, default: -> { true }
  validates :title, presence: true
  validates :content, presence: true

  validates :link, presence: true, allow_blank: true,
                   format: { with: /.(jpg|png)\Z/i, message: 'must be a URL for JPG or PNG image.' }
end
