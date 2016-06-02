class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  default_scope { order(best: :desc) }

  validates :body, presence: true, length: { minimum: 5 }
  validates :question_id, :user_id, presence: true
end
