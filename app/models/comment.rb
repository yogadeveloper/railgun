class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, :commentable_id, :commentable_type, presence: true
  validates :body, presence: true, length: { minimum: 5 }

  def commentable_path_id
    ((self.commentable_type) == 'Question')? self.commentable_id : self.commentable.question_id
  end
end
