require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user}

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }

  describe 'commentable_path_id method' do
    let(:question){ create(:question) }
    let(:question2){ create(:question) }
    let(:answer){ create(:answer, question: question2) }
    let(:comment1){ create(:comment, commentable: question) }
    let(:comment2){ create(:comment, commentable: answer) }

    it 'returns question_id if comentable is question' do
      expect(comment1.commentable_path_id).to eq question.id
    end

    it 'returns answers question_id if comentable is answer' do
      expect(comment2.commentable_path_id).to eq question2.id
    end
  end
end
