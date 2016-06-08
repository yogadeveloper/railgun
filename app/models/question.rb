class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :title, length: { minimum: 5  }, presence: true
  validates :body,  length: { minimum: 5 }, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
