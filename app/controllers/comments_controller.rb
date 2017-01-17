class CommentsController < ApplicationController

  after_action :publish_comment, only: [:create]

  def new
    @answer = Answer.find(params[:answer_id])
    @comment = @answer.comments.build
  end

  def create
    @answer = Answer.find_by(id: params[:answer_id])
    @comment = @answer.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def edit
    @answer = Answer.find_by(id: params[:answer_id])
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  end

 

  def update
    @answer = Answer.find_by(id: params[:answer_id])
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  end

  def destroy
    @answer = Answer.find_by(id: params[:answer_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
  end



  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      'comments',
      render_to_string(template:'comments/comment.json.jbuilder')
      )
  end
 
end
