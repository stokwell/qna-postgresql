module Voted
  extend ActiveSupport::Concern
  
  included do
    before_action :load_votable, only: [:upvote, :downvote, :cancel]
  end

  def upvote
    if vote_empty
      @votable.upvote(current_user)
      render json: { id: @votable.id, status: 'success', count_upvotes: @votable.count_upvotes }, status: :ok
    end
  end

  def downvote
    if vote_empty
      @votable.downvote(current_user)
      render json: { id: @votable.id, status: 'success', count_downvotes: @votable.count_downvotes }, status: :ok
    end
  end

  def cancel
    @votable.cancel(current_user)
    render json: { id: @votable.id, status: 'success', count_upvotes: @votable.count_upvotes, count_downvotes: @votable.count_downvotes }, status: :ok
  end

  
  private
  
  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def vote_empty
    @votable = model_klass.find(params[:id])
    nil == Vote.find_by(user_id: current_user.id, votable: @votable)
  end

end