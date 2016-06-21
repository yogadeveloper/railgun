class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
          omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy


  def owner_of?(item)
    item.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    if email
      user = User.where(email: email).first
    else
      return User.new
    end

    if user
      user.create_auth(auth, false)
      ConfirmOauth.email_confirmation(user).deliver_now
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_auth(auth, true)
    end
    user
  end

  def create_auth(auth, confirmed)
    token = Devise.friendly_token[0, 20]
    authorizations.create(provider: auth.provider, uid: auth.uid, token: token, confirmed: confirmed)
  end
end
