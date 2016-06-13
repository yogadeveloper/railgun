# encoding: utf-8
# frozen_string_literal: true
require 'rails_helper'

describe Question do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

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

  it_behaves_like 'votable'
end
