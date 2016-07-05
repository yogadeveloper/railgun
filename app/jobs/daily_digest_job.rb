class DailyDigestJob < ActiveJob::Base
  queue_as :mailers

  def perform
    questions = Question.where(created_at: Time.now.yesterday.all_day)

    if questions.present?
      User.find_each do |user|
        DailyMailer.delay.digest(user, questions)
      end
    end
  end
end
