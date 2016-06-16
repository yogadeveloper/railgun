class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :mark_as_best]
  before_action :author?, only: [:update, :destroy]

  respond_to :js, only: [:create, :update, :destroy]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    @answer.save
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @question = @answer.question
    respond_with(@answer.destroy)
  end

  def update
    respond_with(@answer.update(answer_params))
    @question = @answer.question
  end

  def mark_as_best
    @question = @answer.question
    if current_user.owner_of?(@question)
      @answer.make_best!
    end
  end

  private

  def author?
    redirect_to_question unless current_user.owner_of?(@answer)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
