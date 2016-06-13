class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable
  
  belongs_to :question
  belongs_to :user

  default_scope { order(best: :desc) }

  validates :body, presence: true, length: { minimum: 5 }
  validates :question_id, :user_id, presence: true

  def make_best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
