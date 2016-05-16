require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      
      it 'saves the new answer in the database' do
        expect { 
          post :create, question_id: question, answer: attributes_for(:answer) 
          }.to change(question.answers, :count).by(1) 
      end

      it 'redirects to answers show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attribues' do
      it 'does not save the answer' do
        expect { 
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end
    
      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to redirect_to question_path(question)
      end
    end    
  end

  describe 'DELETE #destroy' do

    context 'answer belongs to user' do
      it 'destroys answer' do
        expect { delete :destroy, id: answer.id 
          }.to change(@user.answers, :count).by(-1)
      end
      it 'redirects to current question' do
        delete :destroy, id: answer.id, question_id: question
        expect(response).to render_template :destroy
      end
    end

    context 'answer belongs to another user' do
      let(:new_user) { create :user }
      before { sign_in(new_user) }

      it 'does not destroy answer' do
        expect { delete :destroy, id: answer.id}.to_not change(Answer, :count)
      end
    end
  end
end

