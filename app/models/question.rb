class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates_length_of :body, minimum: 40
  validates_length_of :title, minimum: 5
end
