class Post < ApplicationRecord
  attribute :visible, :boolean, default: -> { true }
end
