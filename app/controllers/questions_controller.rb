class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.new
    @answer.attachments.new
    @comment = @question.comments.new
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params.merge(user_id: current_user.id))

    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json

      redirect_to @question, notice: 'Question successfully created'
    else
      flash[:notice] = 'Title and body length should be no less than 5 letters'
      render :new
    end
  end

  def destroy
    if current_user.owner_of?(@question)
      if @question.destroy
        PrivatePub.publish_to "/questions/destroy", question: @question.to_json
        redirect_to root_path, notice: 'Question succesfully destroyed'
      end
    else
      render 'questions/show', notice: 'You are not the owner of this question'
    end
  end

  def update
    @question.update(question_params)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
