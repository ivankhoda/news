class Post < ApplicationRecord
  attribute :visible, :boolean, default: -> { true }
  validates :title, presence: true
  validates :text, presence: true
  validates :link, presence: true
end
