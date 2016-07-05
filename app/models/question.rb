class Question < ActiveRecord::Base
  after_create :subscribe_to_question

  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, foreign_key: 'question_sub_id', dependent: :destroy
  has_many :sub_users, through: :subscriptions

  validates :title, length: { minimum: 5  }, presence: true
  validates :body,  length: { minimum: 5 }, presence: true
  validates :user_id, presence: true

  after_create :update_reputation

  private

  def subscribe_to_question
    self.user.subscribe!(self.id)
  end

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
