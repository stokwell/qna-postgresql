class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :is_current_user_question_owner, only: [:destroy]
  
  def index
    @questions = Question.all.order("created_at desc")
    @question = Question.new
  end

  def show
    @answer = Answer.new
    @answers = Answer.order("created_at desc")
  end

  def new
    @question = Question.new
  end

  def edit
    @question.update(question_params)
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
     @question.update(question_params)
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
