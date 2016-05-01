class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, :question_id, presence: true, length: { minimum: 5 }
end
