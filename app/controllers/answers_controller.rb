class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :is_current_user_answer_owner, only: :destroy
  
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(id: @question.id)
      flash[:notice] = "Your answer was successfully created." 
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy 
    if @answer.destroyed?
      redirect_to @answer.question, notice: 'Answer is deleted.'
    else
      redirect_to @answer.question
    end
  end
 
  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def is_current_user_answer_owner
    @answer = Answer.find(params[:id])
    unless @answer.user_id == current_user.id
      redirect_to @answer.question, alert: 'Not allowed.'
    end
  end

  def answer_params
    params.require(:answer).permit(:body, :title)
  end

end