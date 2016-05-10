class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :new, :create, :show]
  #def index
  #  @answers = @question.answers
  #end

  def show
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Your reply has been successfully posted'
    else
      redirect_to @question, notice: 'Your message is too short. Please, don\'t be so laconical'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end
end
