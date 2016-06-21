class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :build_answer, only: :show
  before_action :author?, only: [:destroy]
  after_action :publish_question, only: :create
  after_action :publish_destroy, only: :destroy

  respond_to :js, only: [:update]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user_id: current_user.id)))
  end

  def destroy
    if current_user.owner_of?(@question)
      @question.destroy
      redirect_to root_path, notice: 'Question succesfully destroyed'
    end
  end

  def update
    @question.update(question_params)
  end

  private

  def publish_question
    PrivatePub.publish_to("/questions", question: @question.to_json) if @question.valid?
  end

  def publish_destroy
    PrivatePub.publish_to("/questions/destroy", question: @question.to_json)
  end

  def author?
    redirect_to_question if !current_user.owner_of?(@question)
  end

  def redirect_to_question
    redirect_to @question
    flash[:notice] = 'You are not the owner of this question'
  end

  def build_answer
     @answer = @question.answers.build
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
