class Question < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, length: { minimum: 5  }, presence: true
  validates :body,  length: { minimum: 5 }, presence: true
  validates :user_id, presence: true
end
