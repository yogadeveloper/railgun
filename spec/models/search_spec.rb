require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe 'search request' do
    describe 'if context is valid' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: question, user: user) }

      before do
        index
      end

      it "return valid array for 'all' search" do
        expect(Search.request('', 'all')).to match_array [user, question, answer, comment]
      end

      it "return valid array for 'questions' search" do
        expect(Search.request(question.title, 'questions')).to match_array [question]
      end

      it "return valid array for 'answers' search" do
        expect(Search.request(answer.body, 'answers')).to match_array [answer]
      end

      it "return valid array for 'comments' search" do
        expect(Search.request(comment.body, 'comments')).to match_array [comment]
      end
      it "return valid array for 'users' search" do
        expect(Search.request(user.email, 'users')).to match_array [user]
      end
    end

    it 'returns empty array if context is wrong' do
      user = create(:user)
      create(:question, user: user)
      index

      expect(Search.request('', 'invalid')).to match_array []
    end
  end
end
