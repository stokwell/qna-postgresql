module Votable

  extend ActiveSupport::Concern

    included do 
      has_many :votes, as: :votable, dependent: :destroy
    end
    
    def count_upvotes
      votes.sum(:upvotes)
    end

    def count_downvotes
      votes.sum(:downvotes)
    end

    def upvote(user)
      votes.where(user: user).first_or_initialize.tap do |vote|
        vote.update_attribute(:upvotes, 1)
      end
    end

    def downvote(user)
      votes.where(user: user).first_or_initialize.tap do |vote|
        vote.update_attribute(:downvotes, 1)
      end
    end

    def cancel(user)
      votes.where(user_id: user.id).destroy_all
    end

end