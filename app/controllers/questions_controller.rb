class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :is_current_user_question_owner, only: [:destroy]
  
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end
  
  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to  questions_path
      flash[:notice] = 'Your question successfully created.' 
    else
      render :new
    end
  end


  def update 
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end   
  end

  def destroy
    @question.destroy 
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def is_current_user_question_owner
    unless @question.user_id == current_user.id
      redirect_to @question, alert: 'Not allowed.'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end




end
