class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]

  authorize_resource class: Answer

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])

    respond_with @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
    respond_with(@answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
