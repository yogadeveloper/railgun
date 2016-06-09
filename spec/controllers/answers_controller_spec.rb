require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, question: question, user: @user) }
  let(:user2) { create(:user) }
  let(:answer2) { create(:answer, question: question, user: user2) }
  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves the new answer in the database' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
          }.to change(question.answers, :count).by(1)
      end
      it 'belongs to current user' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
          }.to change(@user.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attribues' do
      it 'does not save the answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template 'answers/create'
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'answer belongs to user' do
      it 'destroys answer' do
        expect { delete :destroy, id: answer.id
          }.to change(@user.answers, :count).by(-1)
      end
      it 'renders initial view' do
        delete :destroy, id: answer.id, question_id: question
        expect(response).to render_template 'answers/destroy'
      end
    end

    context 'answer belongs to another user' do
      let(:new_user) { create :user }
      let(:new_answer) { create :answer, question: question, user: new_user }

      it 'cannot be destroyed' do
        expect { @user.answers.find(new_answer.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end
    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'PATCH #mark_as_best' do
    before { patch :mark_as_best, id: answer, format: :js }

    it 'changes answer best attribute' do
      answer.reload
      expect(answer.best).to eq true
    end
  end

  describe 'POST #vote_up' do
    context 'non-owner' do
      before do
        sign_in(user2)
      end

      it 'up_vote the answer' do
        expect(answer.rating).to eq 0
        post :vote_up, model: answer, id: answer.id, rating: 1, format: :json
        expect(answer.rating).to eq 1
      end
    end

    context 'answer owner' do
      before do
        sign_in(@user)
      end

      it "can't up_vote, returns error" do
        expect(answer.rating).to eq 0
        post :vote_up, model: answer, id: answer.id, rating: 1, format: :json
        expect(answer.rating).to eq 0
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #vote_down' do
    context 'non-owner' do
      before do
        sign_in user2
      end

      it 'down_vote the answer' do
        expect(answer.rating).to eq 0
        post :vote_down, model: answer, id: answer.id, rating: -1, format: :json
        expect(answer.rating).to eq(-1)
      end
    end

    context "answer's owner" do
      before do
        sign_in(@user)
      end

      it "can't down_vote the answer, returns error" do
        expect(answer.rating).to eq 0
        post :vote_down, model: answer, id: answer.id, rating: -1, format: :json
        expect(answer.rating).to eq 0
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #remove_vote' do
    context "answer's non-owner" do
      before do
        sign_in(user2)
      end

      it 'remove vote' do
        post :vote_up, model: answer, id: answer.id, rating: 1, format: :json
        expect(answer.rating).to eq 1
        post :remove_vote, model: answer, id: answer.id, rating: 0, format: :json
        expect(answer.rating).to eq 0
      end
    end

    context "answer's owner" do
      before do
        sign_in(@user)
      end

      it "can't remove vote, returns error" do
        post :remove_vote, model: answer, id: answer.id, rating: -1, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
