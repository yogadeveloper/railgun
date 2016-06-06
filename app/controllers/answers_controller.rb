class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :mark_as_best]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy if current_user.owner_of?(@answer)
    if @answer.destroy
      flash[:notice] = 'Your answer has been successfully removed'
    else
      render head: :forbidden
    end
  end

  def update
    @question = @answer.question
    if current_user.owner_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def mark_as_best
    @question = @answer.question
    if current_user.owner_of?(@question)
      @answer.make_best!
  end
end

private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
