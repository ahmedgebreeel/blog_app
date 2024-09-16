class Post < ApplicationRecord
  belongs_to :user
  validates :title, :body, :tags, presence: true
end
