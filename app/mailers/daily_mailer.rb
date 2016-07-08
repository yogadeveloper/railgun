class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @user = user
    @questions = questions

    mail(to: @user.mail, subject: 'RailGun flow')
  end
end
