class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_parent
  after_action :publish_comment, only: [:create]
  before_action :load_comment, only:[:edit, :update, :destroy]
  respond_to :js

  def new
  end

  def create
    respond_with(@comment = @parent.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  def edit
    @comment.update(comment_params)
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    respond_with @comment.destroy
  end



  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id]) 
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      'comments',
      render_to_string(template:'comments/comment.json.jbuilder')
      )
  end
 
end
