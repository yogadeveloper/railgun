require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many :question_subs }

  it { should respond_to(:owner_of?) }

  let(:owner) { create :user }
  let(:question) { create :question, user: owner }
  let(:non_owner) { create :user }

  describe '#owner_of?' do
    it 'returns true if item belongs to current user' do
      expect(owner).to be_owner_of question
    end

    it 'returns false if item is not belongs to current user' do
      non_owner.questions << question
      expect(owner).to_not be_owner_of question
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'User already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
          expect(authorization.confirmed).to eq false
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
          expect(authorization.confirmed).to eq true
        end
      end
    end
  end

  describe 'subscription methods' do
    let(:user){ create(:user) }
    let(:user2){ create(:user) }
    let!(:question){ create(:question, user: user2) }

    describe 'subscribe!' do
     it 'creates subscription to question' do
       expect{ user.subscribe!(question.id) }.to change(user.subscriptions, :count).by(1)
     end

     it 'does not creates subscription again' do
       create(:subscription, question_sub_id: question.id, sub_user_id: user.id)
       expect{ user.subscribe!(question.id) }.to_not change(Subscription, :count)
     end
    end

    describe 'unsubscribe!' do
     it 'deletes subscription to question' do
       create(:subscription, question_sub_id: question.id, sub_user_id: user.id)
       expect{ user.unsubscribe!(question.id) }.to change(Subscription, :count).by(-1)
     end

     it 'do nothing if there is no sub' do
       question.subscriptions.delete_all
       expect{ user.unsubscribe!(question.id) }.to_not change(Subscription, :count)
     end
    end

    describe 'subscribed?' do
     it 'returns true if user subscribed to question' do
       create(:subscription, question_sub_id: question.id, sub_user_id: user.id)
       expect(user).to be_subscribed(question)
     end

     it 'returns false if user not subscribed to question' do
       expect(user).to_not be_subscribed(question)
     end
    end
  end
end
