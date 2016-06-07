class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
    else
      render 'questions/show', notice: 'Your message is too short. Please, don\'t be so laconical'
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy if current_user.owner_of?(@answer)
    redirect_to @answer.question
    if @answer.destroy
      flash[:notice] = 'Your answer has been successfully removed' 
    else
      render head: :forbidden
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
