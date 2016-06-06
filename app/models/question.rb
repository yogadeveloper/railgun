class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments

  validates :title, length: { minimum: 5  }, presence: true
  validates :body,  length: { minimum: 5 }, presence: true
  validates :user_id, presence: true
end
