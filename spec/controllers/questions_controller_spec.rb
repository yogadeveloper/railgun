require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question2) { create(:question, user: user2) }

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

      it 'publish question to /questions' do
        expect(PrivatePub).to receive(:publish_to).with("/questions", anything)
        post :create, question: attributes_for(:question)
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
      it 'does not publish question to /questions' do
        expect(PrivatePub).to_not receive(:publish_to).with("/questions", anything)
        post :create, question: attributes_for(:invalid_question)
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
      patch :update, id: question, user_id: user.id, question: { body: 'some...body' }, format: :js
      expect(question.body).to eq 'some...body'
    end
  end

  describe 'POST #vote_up' do
    context 'non-owner' do
      before do
        sign_in(user2)
      end

      it 'up_vote the question' do
        expect(question.rating).to eq 0
        post :vote_up, model: question, id: question.id, rating: 1, format: :json
        expect(question.rating).to eq 1
      end
    end

    context 'question owner' do
      before do
        sign_in(user)
      end

      it "can't up_vote, returns error" do
        expect(question.rating).to eq 0
        post :vote_up, model: question, id: question.id, rating: 1, format: :json
        expect(question.rating).to eq 0
        expect(response.status).to eq 302
      end
    end
  end

  describe 'POST #vote_down' do
    context 'non-owner' do
      before do
        sign_in(user2)
      end

      it 'down_vote the question' do
        expect(question.rating).to eq 0
        post :vote_down, model: question, id: question.id, rating: -1, format: :json
        expect(question.rating).to eq(-1)
      end
    end

    context "question's owner" do
      before do
        sign_in(user)
      end

      it "can't down_vote the question, returns error" do
        expect(question.rating).to eq 0
        post :vote_down, model: question, id: question.id, rating: -1, format: :json
        expect(question.rating).to eq 0
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE #remove_vote' do
    context "question's non-owner" do
      before do
        sign_in(user2)
      end

      it 'remove vote' do
        post :vote_up, model: question, id: question.id, rating: 1, format: :json
        expect(question.rating).to eq 1
        post :remove_vote, model: question, id: question.id, rating: 0, format: :json
        expect(question.rating).to eq 0
      end
    end

    context "question's owner" do
      before do
        sign_in(user)
      end

      it "can't remove the vote, returns error" do
        post :remove_vote, model: question, id: question.id, rating: -1, format: :json
        expect(response.status).to eq 302
      end
    end
  end

end
