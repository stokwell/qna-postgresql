class AnswersController < ApplicationController
  before_action :find_question, only: :create
  
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to question_path(id: @question.id)
    else
      render :new
    end
  end
 
  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :title)
  end

end
