class ConfirmOauth < ApplicationMailer
  default from: "auth@railgun.com"

  def email_confirmation(user)
    @user = user
    auth = @user.authorizations.last
    @url = confirm_auth_url(token: auth.token)
    mail(to: @user.email, subject: "RailGun Community. Please confirm your authorization")
  end
end
