class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy]
  
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params.merge(user_id: current_user.id))
    
    if @question.save
      redirect_to @question, notice: 'Question successfully created'
    else
      flash[:notice] = 'Title and body length should be no less than 5 letters'
      render :new 
    end
  end

  def destroy
    if current_user.owner_of?(@question)
      @question.destroy 
      redirect_to root_path
      flash[:notice] ='Question succesfully destroyed'      
    else
      render 'questions/show', notice: 'You are not the owner of this question'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body, )
  end
end
