class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :update, :best]
  before_action :find_answer, only: [:destroy, :update]
  before_action :is_current_user_answer_owner, only: :destroy

  after_action :publish_answer, only: [:create]

  respond_to :js, :json
  
  include Voted

  def new
  end

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def edit
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
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

  def publish_answer
    @question = Question.find_by(id: params[:question_id])
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      'answers',
       render_to_string(template: 'answers/answer.json.jbuilder')
    )
  end 


  def answer_params
    params.require(:answer).permit(:body, :title, attachments_attributes: [:file, :id, :_delete])
  end

end
