class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :is_current_user_question_owner, only: [:destroy]
  
  after_action :publish_question, only: [:create]


  include Voted

  def index
    @questions = Question.all.order("created_at asc")
    @question = Question.new
  end

  def show
    @answer = Answer.new
    @answers = Answer.all
    @comment= @answer.comments.build
    @comments = @answer.comments.all
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
    @question.update(question_params)
  end
  
  def create
    @seminar = Seminar.find_by(id: params[:seminar_id])
    @question = @seminar.questions.build(question_params)
    @question.user = current_user
    if @question.save
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

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions', 
      ApplicationController.render(
        partial: 'questions/question_in_list',
        locals: { q: @question}
  
      )
    )
  end  

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_delete])
  end

end
