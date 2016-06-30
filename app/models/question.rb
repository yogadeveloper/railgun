class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, length: { minimum: 5  }, presence: true
  validates :body,  length: { minimum: 5 }, presence: true
  validates :user_id, presence: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end
