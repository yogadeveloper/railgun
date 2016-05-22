require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, question: question, user: @user) }

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
        expect(response).to render_template 'questions/show'
      end
    end    
  end

  describe 'DELETE #destroy' do

    context 'answer belongs to user' do
      it 'destroys answer' do
        expect { delete :destroy, id: answer.id 
          }.to change(@user.answers, :count).by(-1)
      end
      it 'redirect to current question' do
        delete :destroy, id: answer.id, question_id: question
        expect(response).to redirect_to question_path(question)
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
end

