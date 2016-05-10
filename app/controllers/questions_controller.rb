class QuestionsController < ApplicationController
  before_action :load_question, only: [:show]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    
    if @question.save
      redirect_to @question, notice: 'Question successfuly created'
    else
      redirect_to new_question_path, notice: 'Title and body length should be no less than 5 letters'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
