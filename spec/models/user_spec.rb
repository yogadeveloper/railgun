require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many :answers }
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
end