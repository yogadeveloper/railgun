class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, :question_id, presence: true
  validates_length_of :body, minimum: 5

end
