class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: :destroy
  before_action :is_current_user_answer_owner, only: :destroy
  
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy 
    redirect_to @answer.question, notice: 'Answer is deleted.'
  end
 
  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def is_current_user_answer_owner
    unless @answer.user_id == current_user.id
      redirect_to @answer.question, alert: 'Not allowed.'
    end
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end 


  def answer_params
    params.require(:answer).permit(:body, :title)
  end

end
