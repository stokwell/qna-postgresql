class VotesController < ApplicationController
before_action :authenticate_user!
before_action :load_votable
before_action :author_votable

respond_to :json

 def up
    if vote_empty
      vote_it 1 
    else
      render nothing: true, status: :forbidden
    end
  end


  def down
    if vote_empty
      vote_it -1
    else
      render nothing: true, status: :forbidden
    end
  end

  def cancel
    @vote = Vote.find_by(user_id: current_user.id, votable: @votable)
    if @vote.user_id == current_user.id
      @vote.destroy
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id } 
    else
      render nothing: true, status: :forbidden
    end
  end


private

  def load_votable  
    @votable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end

  def vote_it(value)
    @vote = Vote.new(value: value, user_id: current_user.id, votable: @votable)
    if @vote.save
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
    end   
  end

  def vote_empty
    nil == Vote.find_by(user_id: current_user.id, votable: @votable)
  end
  
  def author_votable
      render nothing: true, status: :forbidden unless @votable.user_id != current_user.id
  end

end
