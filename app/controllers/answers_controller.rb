class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :update, :best]
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

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Answer is deleted' if @answer.destroy
  end

   
  def best
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.best if current_user.id == @answer.question.user_id
  end
   
 
  private

  def find_answer
    @answer = Answer.find(params[:id])
  end 

  def find_question
    @question = Question.find_by(id: params[:question_id])
  end

  def is_current_user_answer_owner
    unless @answer.user_id == current_user.id
      redirect_to @answer.question, alert: 'Not allowed.'
    end
  end

  def answer_params
    params.require(:answer).permit(:body, :title, attachments_attributes: [:file])
  end

end
