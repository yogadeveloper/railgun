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
  has_many :subscriptions, foreign_key: 'sub_user_id', dependent: :destroy
  has_many :question_subs, through: :subscriptions


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
      ConfirmOauth.email_confirmation(user).deliver_later
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_auth(auth, true)
    end
    user
  end

  #def self.send_daily_digest
  #  find_each.each do |user|
  #    DailyMailer.digest(user).deliver_later
  #  end
  #end

  def create_auth(auth, confirmed)
    token = Devise.friendly_token[0, 20]
    authorizations.create(provider: auth.provider, uid: auth.uid, token: token, confirmed: confirmed)
  end

  def subscribe!(question_id)
  subscriptions.create!(question_sub_id: question_id) unless subscribed?(question_id)
end

  def unsubscribe!(question_id)
    subscriptions.find_by(question_sub_id: question_id).destroy! if subscribed?(question_id)
  end

  def subscribed?(question_id)
    subscriptions.find_by(question_sub_id: question_id)
  end
end
