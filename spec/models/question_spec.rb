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

  it {should accept_nested_attributes_for :attachments }

  it 'should calculate reputation after creating' do
    expect(Reputation).to receive(:calculate).with(subject)
    subject.save!
  end

  it 'should not calculate reputation after update' do
    subject.save!
    expect(Reputation).to_not receive(:calculate)
    subject.update(title: '123')
  end

  it 'should save user reputation' do
    allow(Reputation).to receive(:calculate).and_return(5)
    expect { subject.save! }.to change(user, :reputation).by(5)
  end

  it_behaves_like 'votable'
end
