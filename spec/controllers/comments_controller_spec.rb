require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:question) {create(:question, user: @user) }
  let!(:answer) { create(:answer, user: @user, question: question) }

  describe 'POST #create' do

    context 'valid comment' do
      it 'assigns question to @commentable' do
        post :create, commentable: 'questions', question_id: question,
                              comment: attributes_for(:comment), format: :js
        expect(assigns(:commentable)).to eq question
      end

      it 'saves the question comment in db' do
        expect { post :create, commentable: 'questions', question_id: question,
                                                            comment: attributes_for(:comment), format: :js
        }.to change(question.comments, :count).by(1) && change(@user.comments, :count).by(1)
      end

      it 'assigns answer to @commentable' do
        post :create, commentable: 'answers', answer_id: answer,
                                              comment: attributes_for(:comment), format: :js
        expect(assigns(:commentable)).to eq answer
      end

      it 'saves the answer commet in db' do
        expect { post :create, commentable: 'answers', answer_id: answer,
                                                       comment: attributes_for(:comment), format: :js
               }.to change(answer.comments, :count).by(1) && change(@user.comments, :count).by(1)
      end
    end

    context 'with invalid comment' do
      it 'cannot save' do
        expect {
          post :create, commentable: 'questions', question_id: question,
                                                  comment: attributes_for(:invalid_comment), format: :json
                                                }.to_not change(Comment, :count)
      end
    end
  end
end
