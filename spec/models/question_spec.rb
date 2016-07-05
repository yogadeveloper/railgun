# encoding: utf-8
# frozen_string_literal: true
require 'rails_helper'

describe Question do
  subject { build(:question, user: user) }
  let(:user) { create(:user) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_presence_of(:user_id) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:sub_users) }

  describe 'subscribe_to_question' do
    let(:user){ create(:user) }

    it 'subscribes user to question' do
      question = Question.new(title: 'test-title', body: 'test-body', user: user)

      expect{ question.save! }.to change(user.subscriptions, :count).by(1)
    end
  end

  it {should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'

  describe 'reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like 'calculates reputation'
  end


  describe 'subscribe_to_question' do
    let(:user){ create(:user) }

    it 'subscribes user to question' do
      question = Question.new(title: 'test-title', body: 'test-body', user: user)

      expect{ question.save! }.to change(user.subscriptions, :count).by(1)
    end
  end
end
