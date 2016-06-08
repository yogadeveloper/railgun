require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'adds new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'assigns new question to current user and save it to the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'belongs to current user' do
        expect {
          post :create, question_id: question, question: attributes_for(:question)
          }.to change(@user.questions, :count).by(1)
      end

      it  'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes(logged in user)' do
      it 'does not save question' do
        expect {
          post :create, question: attributes_for(:invalid_question)
       }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    context 'question belongs to user' do
      before { @user.questions << question }
      it 'destroys question' do
        expect { delete :destroy, id: question.id
              }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        delete :destroy, id: question.id
        expect(response).to redirect_to root_path
      end
    end

    context 'question belongs to another user' do
      sign_in_user
      before { user.questions << question }
      it 'does not destroy question' do
        expect { delete :destroy, id: question.id }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns the requested question to @question' do
      patch :update, id: question, user_id: user, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attr' do
      patch :update, id: question, user_id: user, question: { body: 'some...body' }, format: :js
      question.reload
      expect(question.body).to eq 'some...body'
    end
    it 'render update template' do
      patch :update, id: question, user_id: user, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end
end
