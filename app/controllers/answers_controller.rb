class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_answer, only: [:destroy]
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      redirect_to @question, notice: 'Your reply has been successfully posted'
    else
      render 'questions/show', notice: 'Your message is too short. Please, don\'t be so laconical'
    end
  end

  def destroy
    if current_user.owner_of?(@answer)
      @answer.destroy 
      render 'questions/show', notice: 'Your answer has been successfully removed'
    else
      flash[:notice] = 'You cannot remove this answer'
    end
  end
  
  private

  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
