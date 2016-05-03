class Answer < ActiveRecord::Base
  belongs_to :question 

  validates :body, presence: true, length: { minimum: 5 }
  validates :question_id, presence: true 
end
