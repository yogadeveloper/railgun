require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    it 'populates an array of all answers for this question' do
      question = create(:question)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, question: question)
      get :index, question_id: question
      expect(assigns(:answers)).to match_array([answer1, answer2])
    end
  end
  
  describe 'GET #new' do
    before { get :new, question_id: question.id }
      
    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
      end

    it 'renders new view' do
      expect(response).to render_template :new
      end
  end

  describe 'GET #show' do
    before { get :show, question_id: question, id: answer }
  
      xit 'assigns the requested answer to @answer'
  end

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
        }.to_not change(question.answers, :count)
      end
    
      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template(:new) 
      end
    end    
  end
end

