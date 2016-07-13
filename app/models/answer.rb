class Answer < ActiveRecord::Base
  after_create :notify_users

  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  scope :best_first, -> { order('best DESC', 'created_at') }

  validates :body, presence: true, length: { minimum: 5 }
  validates :question_id, :user_id, presence: true

  def make_best!
    transaction do
      question.answers.where(best: true).update_all(best: false, updated_at: Time.now)
      update!(best: true)
    end
  end

  after_create :update_reputation

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def notify_users
    NewAnswerNotificationJob.perform_later(self)
  end
end
