class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

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
