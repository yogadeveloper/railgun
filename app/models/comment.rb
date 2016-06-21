class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, :commentable_id, :commentable_type, presence: true
  validates :body, presence: true, length: { minimum: 5 }
end
