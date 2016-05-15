# encoding: utf-8
# frozen_string_literal: true
require 'rails_helper'

describe Question do
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
end
