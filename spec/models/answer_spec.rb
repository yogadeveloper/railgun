require 'rails_helper'

describe Answer do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should have_db_column(:best).of_type(:boolean).with_options(default: false) }

  it_behaves_like 'votable' do
    let(:votable) { create(:answer, user: user, question:question) }
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user)}
    subject { build(:answer, user: user, question: question) }

    it_behaves_like 'calculates reputation'
  end

  describe 'notify_users method' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }

    it 'calls background job' do
      answer = Answer.new(body: 'answer body', question: question, user: user)
      expect(NewAnswerNotificationJob).to receive(:perform_later).with(answer)
      answer.save
      answer.committed!
    end
  end
end
